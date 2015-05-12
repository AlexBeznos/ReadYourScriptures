$(document).ready(function() {
  $('.check_all').on('click', function() {
    var inputs = $('.' +  this.id + ' input[type="checkbox"]');


    if(inputs[0].checked) {
      inputs.prop('checked', false);
    } else {
      inputs.prop('checked', true);
    }
  });
});
