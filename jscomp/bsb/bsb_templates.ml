(* This file has been generated by ocp-ocamlres *)
let root = OCamlRes.Res.([
  Dir ("basic", [
    Dir ("src", [
      File ("demo.ml",
        "\n\
         \n\
         let () = Js.log \"Hello, BuckleScript\"")]) ;
    File ("README.md",
      "\n\
       \n\
       # Build\n\
       ```\n\
       npm run build\n\
       ```\n\
       \n\
       # Watch\n\
       \n\
       ```\n\
       npm run watch\n\
       ```\n\
       \n\
       \n\
       # Editor\n\
       If you use `vscode`, Press `Windows + Shift + B` it will build automatically") ;
    File ("package.json",
      "{\n\
      \  \"name\": \"${bsb:name}\",\n\
      \  \"version\": \"${bsb:proj-version}\",\n\
      \  \"scripts\": {\n\
      \    \"clean\": \"bsb -clean-world\",\n\
      \    \"build\": \"bsb -make-world\",\n\
      \    \"watch\": \"bsb -make-world -w\"\n\
      \  },\n\
      \  \"keywords\": [\n\
      \    \"BuckleScript\"\n\
      \  ],\n\
      \  \"license\": \"MIT\",\n\
      \  \"devDependencies\": {\n\
      \    \"bs-platform\": \"${bsb:bs-version}\"\n\
      \  }\n\
       }") ;
    File ("bsconfig.json",
      "{\n\
      \  \"name\": \"${bsb:name}\",\n\
      \  \"version\": \"${bsb:proj-version}\",\n\
      \  \"sources\": [\n\
      \    \"src\"\n\
      \  ],\n\
      \  \"bs-dependencies\" : [\n\
      \      // add your bs-dependencies here \n\
      \  ]\n\
       }") ;
    Dir (".vscode", [
      File ("tasks.json",
        "{\n\
        \    \"version\": \"${bsb:proj-version}\",\n\
        \    \"command\": \"npm\",\n\
        \    \"options\": {\n\
        \        \"cwd\": \"${workspaceRoot}\"\n\
        \    },\n\
        \    \"isShellCommand\": true,\n\
        \    \"args\": [\n\
        \        \"run\",\n\
        \        \"watch\"\n\
        \    ],\n\
        \    \"showOutput\": \"always\",\n\
        \    \"isBackground\": true,\n\
        \    \"problemMatcher\": {\n\
        \        \"fileLocation\": \"absolute\",\n\
        \        \"owner\": \"ocaml\",\n\
        \        \"watching\": {\n\
        \            \"activeOnStart\": false,\n\
        \            \"beginsPattern\": \">>>> Start compiling\",\n\
        \            \"endsPattern\": \">>>> Finish compiling\"\n\
        \        },\n\
        \        \"pattern\": [\n\
        \            {\n\
        \                \"regexp\": \"^File \\\"(.*)\\\", line (\\\\d+)(?:, characters (\\\\d+)-(\\\\d+))?:$\",\n\
        \                \"file\": 1,\n\
        \                \"line\": 2,\n\
        \                \"column\": 3,\n\
        \                \"endColumn\": 4\n\
        \            },\n\
        \            {\n\
        \                \"regexp\": \"^(?:(?:Parse\\\\s+)?(Warning|[Ee]rror)(?:\\\\s+\\\\d+)?:)?\\\\s+(.*)$\",\n\
        \                \"severity\": 1,\n\
        \                \"message\": 2,\n\
        \                \"loop\": true\n\
        \            }\n\
        \        ]\n\
        \    }\n\
         }")]) ;
    File (".gitignore",
      "*.exe\n\
       *.obj\n\
       *.out\n\
       *.compile\n\
       *.native\n\
       *.byte\n\
       *.cmo\n\
       *.annot\n\
       *.cmi\n\
       *.cmx\n\
       *.cmt\n\
       *.cmti\n\
       *.cma\n\
       *.a\n\
       *.cmxa\n\
       *.obj\n\
       *~\n\
       *.annot\n\
       *.cmj\n\
       *.bak\n\
       lib/bs\n\
       *.mlast\n\
       *.mliast\n\
       .vscode\n\
       .merlin")]) ;
  Dir ("minimal", [
    Dir ("src", [ File ("main.ml", "")]) ;
    File ("README.md",
      "\n\
      \  # ${bsb:name}") ;
    File ("package.json",
      "{\n\
      \  \"name\": \"${bsb:name}\",\n\
      \  \"version\": \"${bsb:proj-version}\",\n\
      \  \"scripts\": {\n\
      \    \"clean\": \"bsb -clean-world\",\n\
      \    \"build\": \"bsb -make-world\",\n\
      \    \"start\": \"bsb -make-world -w\"\n\
      \  },\n\
      \  \"keywords\": [\n\
      \    \"BuckleScript\"\n\
      \  ],\n\
      \  \"license\": \"MIT\",\n\
      \  \"devDependencies\": {\n\
      \    \"bs-platform\": \"^${bsb:bs-version}\"\n\
      \  }\n\
       }") ;
    File ("bsconfig.json",
      "{\n\
      \  \"name\": \"${bsb:name}\",\n\
      \  \"sources\": [\"src\"]\n\
       }") ;
    File (".gitignore",
      "lib\n\
       node_modules\n\
       .merlin\n\
       npm-debug.log")]) ;
  Dir ("react", [
    File ("webpack.config.js",
      "const path = require('path');\n\
       \n\
       module.exports = {\n\
      \  entry: {\n\
      \    simple: './lib/js/src/simple/simpleRoot.js',\n\
      \    interop: './src/interop/interopRoot.js',\n\
      \  },\n\
      \  output: {\n\
      \    path: path.join(__dirname, \"bundledOutputs\"),\n\
      \    filename: '[name].js',\n\
      \  },\n\
       };\n\
       ") ;
    Dir ("src", [
      Dir ("simple", [
        File ("simpleRoot.re",
          "ReactDOMRe.renderToElementWithId <Page name=\"Lil' Reason\" /> \"index\";\n\
           ") ;
        File ("page.re",
          "let component = ReasonReact.statefulComponent \"Greeting\";\n\
           \n\
           let make ::name _children => {\n\
          \  let click _event state _self => ReasonReact.Update (state + 1);\n\
          \  {\n\
          \    ...component,\n\
          \    initialState: fun () => 0,\n\
          \    render: fun state self => {\n\
          \      let greeting = {j|Hello $name, You've clicked the button $state times(s)!|j};\n\
          \      <button onClick=(self.update click)> (ReasonReact.stringToElement greeting) </button>\n\
          \    }\n\
          \  }\n\
           };\n\
           ") ;
        File ("index.html",
          "<!DOCTYPE html>\n\
           <html lang=\"en\">\n\
           <head>\n\
          \  <meta charset=\"UTF-8\">\n\
          \  <title>Pure Reason Example</title>\n\
           </head>\n\
           <body>\n\
          \  <div id=\"index\"></div>\n\
          \  <script src=\"../../bundledOutputs/simple.js\"></script>\n\
           </body>\n\
           </html>\n\
           ")]) ;
      Dir ("interop", [
        File ("README.md",
          "## Interoperate with Existing ReactJS Components\n\
           \n\
           This subdirectory demonstrate the ReasonReact <-> ReactJS interop APIs.\n\
           \n\
           The entry point, `interopRoot.js`, illustrates ReactJS requiring a ReasonReact component, `PageReason`.\n\
           \n\
           `PageReason` itself illustrates ReasonReact requiring a ReactJS component, `myBanner.js`, through the Reason file `myBannerRe.re`.\n\
           ") ;
        File ("pageReason.re",
          "let component = ReasonReact.statelessComponent \"PageReason\";\n\
           \n\
           let make ::message ::extraGreeting=? _children => {\n\
          \  ...component,\n\
          \  render: fun () _self => {\n\
          \    let greeting =\n\
          \      switch extraGreeting {\n\
          \      | None => \"How are you?\"\n\
          \      | Some g => g\n\
          \      };\n\
          \    <div> <MyBannerRe show=true message=(message ^ \" \" ^ greeting) /> </div>\n\
          \  }\n\
           };\n\
           \n\
           let comp =\n\
          \  ReasonReact.wrapReasonForJs\n\
          \    ::component\n\
          \    (\n\
          \      fun jsProps =>\n\
          \        make\n\
          \          message::jsProps##message\n\
          \          extraGreeting::?(Js.Null_undefined.to_opt jsProps##extraGreeting)\n\
          \          [||]\n\
          \    );\n\
           ") ;
        File ("myBannerRe.re",
          "/* Typing the myBanner.js component's output as a `reactClass`. */\n\
           /* Note that this file's JS output is located at reason-react-example/lib/js/src/interop/myBannerRe.js; we're specifying the relative path to myBanner.js in the string below */\n\
           external myBanner : ReasonReact.reactClass = \"../../../../src/interop/myBanner\" [@@bs.module];\n\
           \n\
           let make ::show ::message children =>\n\
          \  ReasonReact.wrapJsForReason\n\
          \    reactClass::myBanner\n\
          \    props::{\n\
          \      \"show\": Js.Boolean.to_js_boolean show, /* ^ don't forget to convert an OCaml bool into a JS boolean! */\n\
          \      \"message\": message /* OCaml string maps to JS string, no conversion needed here */\n\
          \    }\n\
          \    children;\n\
           ") ;
        File ("myBanner.js",
          "var ReactDOM = require('react-dom');\n\
           var React = require('react');\n\
           \n\
           var App = React.createClass({\n\
          \  render: function() {\n\
          \    if (this.props.show) {\n\
          \      return React.createElement('div', null,\n\
          \        this.props.message\n\
          \      );\n\
          \    } else {\n\
          \      return null;\n\
          \    }\n\
          \  }\n\
           });\n\
           \n\
           module.exports = App;\n\
           ") ;
        File ("interopRoot.js",
          "var ReactDOM = require('react-dom');\n\
           var React = require('react');\n\
           \n\
           // Import a ReasonReact component! `comp` is the exposed, underlying ReactJS class\n\
           var PageReason = require('../../lib/js/src/interop/pageReason').comp;\n\
           \n\
           var App = React.createClass({\n\
          \  render: function() {\n\
          \    return React.createElement('div', null,\n\
          \      React.createElement(PageReason, {message: 'Hello!'})\n\
          \    );\n\
          \    // didn't feel like dragging in Babel. Here's the equivalent JSX:\n\
          \    // <div><PageReason message=\"Hello!\"></div>\n\
          \  }\n\
           });\n\
           \n\
           ReactDOM.render(React.createElement(App), document.getElementById('index'));\n\
           ") ;
        File ("index.html",
          "<!DOCTYPE html>\n\
           <html lang=\"en\">\n\
           <head>\n\
          \  <meta charset=\"UTF-8\">\n\
          \  <title>Pure Reason Example</title>\n\
           </head>\n\
           <body>\n\
          \  <div id=\"index\"></div>\n\
          \  <script src=\"../../bundledOutputs/interop.js\"></script>\n\
           </body>\n\
           </html>\n\
           ")])]) ;
    File ("README.md",
      "This is a repo with examples usages of [ReasonReact](https://github.com/reasonml/reason-react).\n\
       Have something you don't understand? Join us on [Discord](https://discord.gg/reasonml)!\n\
       \n\
       Run this project:\n\
       \n\
       ```\n\
       npm install\n\
       npm start\n\
       # in another tab\n\
       npm run build\n\
       ```\n\
       \n\
       After you see the webpack compilation succeed (the `npm run build` step), open up the nested html files in `src/*` (**no server needed!**). Then modify whichever file in `src` and refresh the page to see the changes.\n\
       ") ;
    File ("package.json",
      "{\n\
      \  \"name\": \"${bsb:name}\",\n\
      \  \"private\": true,\n\
      \  \"version\": \"${bsb:proj-version}\",\n\
      \  \"description\": \"\",\n\
      \  \"main\": \"index.js\",\n\
      \  \"scripts\": {\n\
      \    \"test\": \"echo \\\"Error: no test specified\\\" && exit 1\",\n\
      \    \"start\": \"bsb -make-world -w\",\n\
      \    \"build\": \"webpack -w\",\n\
      \    \"clean\": \"bsb -clean-world\"\n\
      \  },\n\
      \  \"keywords\": [],\n\
      \  \"author\": \"\",\n\
      \  \"license\": \"ISC\",\n\
      \  \"dependencies\": {\n\
      \    \"react\": \"^15.4.2\",\n\
      \    \"react-dom\": \"^15.4.2\",\n\
      \    \"reason-react\": \">=0.1.4\"\n\
      \  },\n\
      \  \"devDependencies\": {\n\
      \    \"bs-platform\": \"^${bsb:bs-version}\",\n\
      \    \"webpack\": \"^1.14.0\"\n\
      \  }\n\
       }\n\
       ") ;
    File ("bsconfig.json",
      "/* This is the BuckleScript configuration file. Note that this is a comment;\n\
      \  BuckleScript comes with a JSON parser that supports comments and trailing\n\
      \  comma. If this screws with your editor highlighting, please tell us by filing\n\
      \  an issue! */\n\
       {\n\
      \  \"name\" : \"${bsb:name}\",\n\
      \  \"reason\" : {\"react-jsx\" : 2},\n\
      \  \"bs-dependencies\": [\"reason-react\"],\n\
      \  \"sources\": [\n\
      \    {\n\
      \      \"dir\": \"src\",\n\
      \      \"subdirs\": [\"interop\", \"simple\"],\n\
      \    }\n\
      \  ],\n\
       }\n\
       ") ;
    File (".gitignore",
      "lib\n\
       node_modules\n\
       .merlin\n\
       npm-debug.log")])
])
