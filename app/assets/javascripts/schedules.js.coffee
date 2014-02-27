$ ->
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
