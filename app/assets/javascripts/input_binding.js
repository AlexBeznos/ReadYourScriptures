$(document).on("ready page:load", function() {
  function show_phone_form() {
    $('.user_phone').hide();
    var type = $("#user_notification_type").val();

    if(type == 'sms'|| type == 'email_and_sms') {
      $('.user_phone').show();
    }
  }

  show_phone_form();
  $('#user_notification_type').change(function() {
    show_phone_form();
  }).change();


});

$(document).ready(function() {
  $('.check_all').on('click', function() {
    $('.' + this.id + ' input[type="checkbox"]').click();
  });
});
