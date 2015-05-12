$(document).ready(function() {
  $('.check_all').on('click', function() {
    $('.' +  this.id + ' input[type="checkbox"]').click();
  });
});
