$(document).ready(function() {
  var tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);

  $('#schedule_start_date').datepicker({
    format: "dd.mm.yyyy",
    weekStart: 0,
    orientation: "top right",
    setDate: tomorrow,
    startDate: tomorrow,
    autoclose: true
  });
});
