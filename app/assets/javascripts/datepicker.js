$(document).ready(function() {
  var today = new Date();

  $('#schedule_start_date').datepicker({
    format: "dd.mm.yyyy",
    weekStart: 0,
    orientation: "top right",
    setDate: today,
    startDate: today,
    autoclose: true
  });
});
