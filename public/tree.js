
;(function(exports) {
  $(document).ready(function(){
    var consoleController = $("#console").console({
      promptLabel: '> ',
      commandValidate: function(line){
        return line !== "";
      },
      commandHandle: function(line) {
        $.ajax({
          type: "POST",
          url: '/form',
          data: { message:line },
          success: function(data2){
            console.log(data2);
            consoleController.commandResult([{msg: data2.returnValue}]);
            makePicture(data2.tree);
          },

          dataType: 'json'
        });

        
      },
      autofocus:true,
      promptHistory:true
    });
  });
  
})(this);