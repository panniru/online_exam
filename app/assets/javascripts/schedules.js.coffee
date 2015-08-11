$ ->
   $('body').on('click', 'a[rel = "question-nav-next"]', (event)->
        console.log("link submission")
        $("#action_for").val("next")
        $("form#ol_exam").submit()
        )

   $('body').on('click', 'a[rel = "question-nav-prev"]', (event)->
        $("#action_for").val("prev")
        $("form#ol_exam").submit()
        )
   $('body').on('click', 'a[rel = "question-nav-submit"]', (event)->
        $("#action_for").val("submit")
        $("form#ol_exam").submit()
        )

   $('body').on('click', 'a[rel = "validation-submit"]', (event)->
        password = $("#entry-password").val()
        reg_id = $("#registration_id").val()
        url = "/schedules/"+reg_id+"/validate_exam_entrance.json?password="+password
        $.post(url, (data) ->
                if data == true || data == 'true'
                    $('#validationModel').modal('toggle')
                else
                    $('#status').addClass("alert alert-danger").html("Invalid Password")
                )
        )

   $("select[rel = 'course_change']").on('change', (event) ->
        if $(this).val().length > 0
            url = "/exams/course_exams_json.json?course_id="+$(this).val()
            parent = $("#schedule-exam-list")
            parent.empty()
            $.getJSON(url, (data)->
                   $.each(data, (index, item) ->
                        $("<option>").val(item[1]).text(item[0]).appendTo(parent)
                        )
                )
        )

   $("[data-countdown]").each ->
        $this = $(this)
        finalDate = $(this).data("countdown")
        $this.countdown finalDate, (event) ->
                $this.html event.strftime("%D days %H:%M:%S")
                if event.strftime("%D-%H-%M-%S") == '00-00-00-00'
                        $("#take_exam").show()

   $("span#time-out-timer").countdown $("#time-out-timer").data("end-countdown"), (event) ->
        $(this).html event.strftime("%H:%M:%S")
        # if event.strftime("%D-%H-%M-%S") == '00-00-00-00'
        #         $("#action_for").val("submit")
        #         $("form#ol_exam").submit()

