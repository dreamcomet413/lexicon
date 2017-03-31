$(document).ready(function(){
  
  $("a.lock-icon").click(function(e) {
    e.preventDefault();
    var el = $(this);
    
    var input = el.siblings(".quantity-input").first();
    if(!el.hasClass('unlock')){
      el.addClass('unlock');
      input.attr("max", 999999);
      input.tooltipster('open', function(instance, helper){
         instance.content("Maximum allowed value is "+ input.data("max-copy") +". On exceeding the maximum quantity level your order will remain in pending state until approved by our staff. You will receive a email about your order's status.");
        });
      input.addClass('mark-input-red');
      input.attr("readonly", false);
    } // else {
     //      input.attr("max", input.data("max-copy"));
     //      input.val(input.attr('min'));
     //      input.tooltipster('close');
     //      input.removeClass('mark-input-red');
     //    }
    return false;
  });
  
  $('.quantity-input').tooltipster({
     animation: 'fade',
     delay: 200,
     timer: 5000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300',
     contentCloning: true
  });
  
  
});