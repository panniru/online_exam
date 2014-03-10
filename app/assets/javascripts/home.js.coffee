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

   $("#chart-1").on("chartkick:after", (e) ->
          alert(e)
        )
