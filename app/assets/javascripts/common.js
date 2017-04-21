$(document).ready(function(){
  
  $('.quantity-input').on("change paste keyup", function(e) {
    var el = $(this);
    var val = parseInt(el.val());
    var min = parseInt(el.data("min"));
    if(val == 0) {
      return true;
    }

    window.clearTimeout($(this).data("timeout"));
    el.data("timeout", setTimeout(function () {
      var val = parseInt(el.val());
      if (val < min) {
        el.tooltipster('open', function(instance, helper){
          instance.content("Minimum allowed value is "+ min +".");
        }); 
        // el.val(0);
      }
    }, 300));

  });
  
  $('.tool-tip-para').on("mouseover", function(e) {
    var el = $(this);
    window.clearTimeout($(this).data("timeout"));
    el.data("timeout", setTimeout(function () {
      var val = parseInt(el.data("max"));
      el.tooltipster('open', function(instance, helper){
        var msg = "Maximum Quantity is " + val + ". Ordering more than " + val + " requires approval after order is placed."
        instance.content(msg);
      }); 
    }, 0));

  });
  
  // $("#new_order").submit(function() {
  //   return !$(".quantity-input").hasClass('error');
  // })
  
  $(".cart-submit").click(function(e) {
    e.preventDefault();
    $('#new_order').submit();
    return false;
  })
  
  $('.quantity-input').tooltipster({
     animation: 'fade',
     delay: 200,
     timer: 3000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300',
     contentCloning: true
  });
  
  $('.quantity-input, .tool-tip-para').tooltipster({
     animation: 'fade',
     delay: 200,
     timer: 3000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300',
     contentCloning: true
  });
  
});