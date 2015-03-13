$ ->
   $('input[id="exam_fill_in_blanks"]').blur( ->
        $('input[id="exam_multiple_choice"]').val($('input[id="exam_no_of_questions"]').val()-$(this).val())
        )

