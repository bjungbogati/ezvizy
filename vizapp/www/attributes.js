
  function myFunction() {
    
    var myAttributes = [
      { attr: "data-toggle", value: "dashboard" }
    ];
    
    
    var link = document.querySelectorAll("li.treeview a")
    
    /*var link = document.getElementsByTagName("a")*/
      
      
      for (var i = 0; i < myAttributes.length; i++) {
        link[i].setAttribute("data-toggle", "tab");
        
        link[i].setAttribute("data-value", myAttributes[i].value);
        
      }
    
  }


window.onload =  myFunction;

