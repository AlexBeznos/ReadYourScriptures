$(document).ready(function() {
  $('#schedule_start_date').datepicker({
    format: "dd.mm.yyyy",
    weekStart: 0,
    orientation: "top right",
    setDate: new Date(),
    startDate: new Date(),
    autoclose: true
  });
});
