(* Copyright (C) 2017- Authors of BuckleScript
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


let (//) = Ext_path.combine

(** TODO: create the animation effect 
    logging installed files
*)
let install_targets ~backend cwd (config : Bsb_config_types.t option) =
  
  let install ~destdir file = 
    if Bsb_file.install_if_exists ~destdir file  then 
      begin 
        ()

      end
  in
  let install_filename_sans_extension destdir namespace nested x = 
    let x = 
      match namespace with 
      | None -> x 
      | Some ns -> Ext_namespace.make ~ns x in 
    install ~destdir (cwd // x ^  Literals.suffix_ml) ;
    install ~destdir (cwd // x ^  Literals.suffix_re) ;
    install ~destdir (cwd // x ^ Literals.suffix_mli) ;
    install ~destdir (cwd // x ^  Literals.suffix_rei) ;
    
    (* The library file generated by bsb for each external dep has the 
       same name because they're in different folders and because it makes
       linking easier. *)
    let artifacts_directory = cwd // Bsb_config.lib_bs // nested in
    install ~destdir (artifacts_directory // Literals.library_file ^ Literals.suffix_a) ;
    install ~destdir (artifacts_directory // Literals.library_file ^ Literals.suffix_cma) ;
    install ~destdir (artifacts_directory // Literals.library_file ^ Literals.suffix_cmxa) ;
    
    install ~destdir (artifacts_directory // x ^ Literals.suffix_cmi) ;
    install ~destdir (artifacts_directory // x ^ Literals.suffix_cmj) ;
    install ~destdir (artifacts_directory // x ^ Literals.suffix_cmt) ;
    install ~destdir (artifacts_directory // x ^ Literals.suffix_cmti) ;
  in   
  match config with 
  | None -> ()
  | Some {files_to_install; namespace; package_name} -> 
    let nested = begin match backend with
      | Bsb_config_types.Js       -> "js"
      | Bsb_config_types.Native   -> "native"
      | Bsb_config_types.Bytecode -> "bytecode"
    end in
    let destdir = cwd // Bsb_config.lib_ocaml // nested in (* lib is already there after building, so just mkdir [lib/ocaml] *)
    if not @@ Sys.file_exists destdir then begin Bsb_build_util.mkp destdir  end;
    begin
      Bsb_log.info "@{<info>Installing started@}@.";
      begin match namespace with 
        | None -> ()
        | Some x -> 
          install_filename_sans_extension destdir None nested  x
      end;
      String_hash_set.iter (install_filename_sans_extension destdir namespace nested) files_to_install;
      Bsb_log.info "@{<info>Installing finished@} @.";
    end



let build_bs_deps cwd ~root_project_dir ~backend ~main_bs_super_errors deps =
  let bsc_dir = Bsb_default_paths.bin_dir in
  let vendor_ninja = bsc_dir // "ninja.exe" in
  let ocaml_dir = Bsb_default_paths.ocaml_dir in
  let all_external_deps = ref [] in
  let all_ocamlfind_dependencies = ref [] in
  let all_ocaml_dependencies = ref Depend.StringSet.empty in
  let all_clibs = ref [] in
  
  (* @Idea could this be parallelized? We're not taking advantage of ninja here 
     and it seems like we're just going one dep at a time when we could parallelize 
              Ben - August 9th 2017 *)
  Bsb_build_util.walk_all_deps  cwd
    (fun {top; cwd} ->
       if not top then
         begin 
           let config_opt = Bsb_ninja_regen.regenerate_ninja 
             ~is_top_level:false
             ~not_dev:true
             ~generate_watch_metadata:false
             ~override_package_specs:(Some deps) 
             ~root_project_dir
             ~forced:true
             ~backend
             ~main_bs_super_errors
             cwd bsc_dir ocaml_dir in (* set true to force regenrate ninja file so we have [config_opt]*)
           let config = begin match config_opt with 
            | None ->
            (* @Speed optimize this to _just_ read the static_libraries field. *)
              Bsb_config_parse.interpret_json 
                ~override_package_specs:(Some deps)
                ~bsc_dir
                ~generate_watch_metadata:false
                ~not_dev:true
                ~backend
                cwd
            | Some config -> config
           end in
           (* Append at the head for a correct topological sort. 
              walk_all_deps does a simple DFS, so all we need to do is to append at the head of 
              a list to build a topologically sorted list of external deps.*)
            if List.mem backend Bsb_config_types.(config.allowed_build_kinds) then begin
              all_clibs := (List.rev Bsb_config_types.(config.static_libraries)) @ !all_clibs;
              all_ocamlfind_dependencies := Bsb_config_types.(config.ocamlfind_dependencies) @ !all_ocamlfind_dependencies;
              all_ocaml_dependencies := List.fold_left (fun acc v -> Depend.StringSet.add v acc) !all_ocaml_dependencies Bsb_config_types.(config.ocaml_dependencies);

              let nested = begin match backend with 
              | Bsb_config_types.Js -> "js"
              | Bsb_config_types.Bytecode -> 
                all_external_deps := (cwd // Bsb_config.lib_ocaml // "bytecode") :: !all_external_deps;
                "bytecode"
              | Bsb_config_types.Native -> 
                all_external_deps := (cwd // Bsb_config.lib_ocaml // "native") :: !all_external_deps;
                "native"
              end in
             let command = 
              {Bsb_unix.cmd = vendor_ninja;
                cwd = cwd // Bsb_config.lib_bs // nested;
                args  = [|vendor_ninja|] ;
                env = Array.append (Unix.environment ()) [| "BSB_BACKEND=" ^ nested |] ;
               } in     
             let eid =
               Bsb_unix.run_command_execv
               command in 
             if eid <> 0 then   
              Bsb_unix.command_fatal_error command eid;
             (* When ninja is not regenerated, ninja will still do the build, 
                still need reinstall check
                Note that we can check if ninja print "no work to do", 
                then don't need reinstall more
             *)
             install_targets ~backend cwd config_opt;
           end
         end
    );
  (* Reverse order here so the leaf deps are at the beginning *)
  (List.rev !all_external_deps, List.rev !all_clibs, List.rev !all_ocamlfind_dependencies, !all_ocaml_dependencies)


let make_world_deps cwd ~root_project_dir ~backend =
  Bsb_log.info "Making the dependency world!@.";
  let (deps, main_bs_super_errors) = Bsb_config_parse.simple_get_from_bsconfig () in
  build_bs_deps cwd ~root_project_dir ~backend ~main_bs_super_errors deps
