toggleOptions = (id) ->
        action = $("form#new_multiple_choice_question").attr('action')
        if $(id).is(':checked')
                $('#question-options').hide()
                if typeof action != 'undefined'
                        $("form#new_multiple_choice_question").attr('action', action.replace("/multiple_choice_questions", "/descriptive_questions"))
        else
                $('#question-options').show()
                if typeof action != 'undefined'
                        $("form#new_multiple_choice_question").attr('action', action.replace("/descriptive_questions", "/multiple_choice_questions"))
$ ->
   $('#multiple_choice_question_is_descriptive').on('change', (event) ->
        toggleOptions(this)
        )

   toggleOptions('#question_is_descriptive')
