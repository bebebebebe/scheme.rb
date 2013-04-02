// require "repl_app.rb"


//  var js_tree = JSON.parse(@tree)
//construct_tree = function(x) {console.log(x);};

;(function(exports) {
  $(document).ready(function(){
    var consoleController = $("#console").console({
      promptLabel: '>',
      commandValidate: function(line){
        return line !== "";
      },
      commandHandle: function(line) {
        $.ajax({
          type: "POST",
          url: '/form',
          data: { message:line },
          success: function(data){
            console.log(data);
            consoleController.commandResult([{msg: data.returnValue}])
          },
          dataType: 'json'
        });

        
      },
      autofocus:true,
      promptHistory:true
    });
  });
  
})(this);
// var myFn = function(line, sdjkfhksdjf) {

//   console.log(line);
// }


// myFn("(+ 1 1)");