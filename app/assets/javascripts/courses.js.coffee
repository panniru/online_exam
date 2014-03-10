class CourseHeirarchy
  @data = null
  @parent = null
  custructor:   ->

  arrangeGrid: (data, parent) ->
    $.each(data, (index, value) ->
        subject = value.subject
        id = value.id
        semester = "Semester-"+value.semester
        exam = value.exam_name
        if $("#" + (parent+"-"+subject).replace(" ", "~")).length == 0
            #$("#content-"+parent).addClass('panel-body')
            $("#content-"+parent).after(CourseHeirarchy.createElement("", subject, 2*2, parent, parent))

        semParent = (parent+"-"+subject).replace(" ", "~")
        if $("#" +semParent+"-"+semester).length == 0
            #$("#content-"+semParent).addClass('panel-body')
            $("#"+semParent).after(CourseHeirarchy.createElement("", semester, 3*3, semParent, parent))

        examParent = (semParent+"-"+semester).replace(" ", "~")
        if $("#" + examParent+"-"+exam).length == 0
            #$("#content-"+examParent).addClass('panel-body')
            $("#"+examParent).after(CourseHeirarchy.createElement(id, exam, 4*4, examParent, parent))
        )
    $("tr[rel = '"+parent+"']").show()

  @createElement: (id, name, level, parent, root) ->
    div = "<tr id = '"+parent+"-"+name+"' rel = '"+parent+"' style = 'display: none' class = '"+root+"'>"
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
        if $("tr[rel="+parent+"]").length == 0
                $.getJSON("/courses/"+$(this).attr('data-id')+"/heirarchy.json", (data)->
                   courseHir = new CourseHeirarchy()
                   courseHir.arrangeGrid(data, parent)
                )
        else
                $("."+parent+"").toggle "fast"
        )
   $('body').on('click', "a[rel='inner-table-grid']", (event)->
        $("tr[rel = '"+$(this).attr('id')+"']").toggle()
        )
