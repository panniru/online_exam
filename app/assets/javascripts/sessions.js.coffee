# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
        $("#sample").on('click', (event) ->
                event.preventDefault()
                new Chartkick.PieChart("chart-1", {"Football":20,"Basketball":30}, {});
                )
