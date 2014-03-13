$ ->
   $('.datepicker').datepicker({ dateFormat: 'dd/mm/yy' });
   unless $.cookie("timezone")
        current_time = new Date()
        $.cookie "timezone", current_time.getTimezoneOffset(),
                path: "/"
                expires: 365

   $('#collapseUser').collapse()
   $('#collapseUser').on('shown.bs.collapse', ->
        $("#Users").addClass("active")
        )
   $('#collapseUser').on('hidden.bs.collapse', ->
        $("#Users").removeClass("active")
        )
   dt = new Date($.now())
   $('#application-timer').html(dt.getDate()+"/"+dt.getMonth()+"/"+dt.getFullYear()+" "+dt.getHours()+":"+dt.getMinutes())
