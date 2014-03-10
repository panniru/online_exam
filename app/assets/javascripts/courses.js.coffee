class CourseHeirarchy
  @data = null
  @parent = null
  custructor:   ->
    alert(data)

  arrangeGrid: (data, parent) ->
    $.each(data, (index, value) ->
        subject = value.subject
        id = value.id
        semester = "Semester-"+value.semester
        exam = value.exam_name
        if $("#" + (parent+"-"+subject).replace(" ", "~")).length == 0
            #$("#content-"+parent).addClass('panel-body')
            $("#content-"+parent).after(CourseHeirarchy.createElement("", subject, 2*2, parent))

        semParent = (parent+"-"+subject).replace(" ", "~")
        if $("#" +semParent+"-"+semester).length == 0
            #$("#content-"+semParent).addClass('panel-body')
            $("#content-"+semParent).after(CourseHeirarchy.createElement("", semester, 3*3, semParent))

        examParent = (semParent+"-"+semester).replace(" ", "~")
        if $("#" + examParent+"-"+exam).length == 0
            #$("#content-"+examParent).addClass('panel-body')
            $("#content-"+examParent).after(CourseHeirarchy.createElement(id, exam, 4*4, examParent))
        )
    $("tr[rel = '"+parent+"']").show()

  @createElement: (id, name, level, parent) ->
    div = "<tr id = 'content-"+parent+"-"+name+"' rel = '"+parent+"' style = 'display: none'>"
    div += "<td class = 'well1 panel-title'>"
    for i in [0..level]
        div += "&nbsp;"

    div += "<a href='#' rel = 'inner-table-grid' id = '"+parent+"-"+name+"' data-parent = '"+parent+"' >"+name+"</a>"
    div += "</td>"
    div += "</tr>"
    return div

$ ->
   $("a[rel='course-drill']").on('click', (event) ->
        parent = $(this).attr('id')
        $.getJSON("/courses/"+$(this).attr('data-id')+"/heirarchy.json", (data)->
           courseHir = new CourseHeirarchy()
           courseHir.arrangeGrid(data, parent)
        )
        )
   $('body').on('click', "a[rel='inner-table-grid']", (event)->
        $("tr[rel = '"+$(this).attr('id')+"']").toggle()
        )
