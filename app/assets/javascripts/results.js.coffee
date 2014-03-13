$ ->
   $("a[rel='print-report']").on('click', ->
        $("form#exam_results").attr('action', '/results/exam_results.pdf')
        $("form#exam_results").submit()
        )
