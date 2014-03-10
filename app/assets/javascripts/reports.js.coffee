$ ->
   $("a[rel='print-report']").on('click', ->
        $("form#exam_results_report").attr('action', '/reports/print.pdf')
        $("form#exam_results_report").submit()
        )
