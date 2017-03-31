$(document).ready(function(){
  
  $("a.lock-icon").click(function(e) {
    e.preventDefault();
    var el = $(this);
    
    var input = el.siblings(".quantity-input").first();
    if(!el.hasClass('unlock')){
      el.addClass('unlock');
      input.attr("max", 999999);
      input.tooltipster('open');
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
     timer: 4000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300'
  });
  
  
});