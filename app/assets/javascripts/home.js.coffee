$ ->
   $('.datepicker').datepicker({ dateFormat: 'dd/mm/yy' });
   unless $.cookie("timezone")
        current_time = new Date()
        $.cookie "timezone", current_time.getTimezoneOffset(),
                path: "/"
                expires: 365
