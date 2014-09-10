(function(angular, app) {
    "use strict";
    app.service("studentService",["$http", function($http) {
        var getStudents = function(courseId, semester, page){
            var url = "/students/students_to_promote.json"
            return $http.get(url, {params: {course_id: courseId, semester: semester, page: page}});
        }

        var p_or_d_all = function(courseId, semester, action){
            var url = "/students/promote_or_demote_all.json"
            return $http.post(url, {course_id: courseId, semester: semester, action_type: action});
        }
        
        var p_or_d = function(students, action, semester){
            var url = "/students/promote_or_demote.json"
            return $http.post(url, {students: students, action_type: action, semester: semester});
        }


        
        return {
            getStudents : getStudents,
            p_or_d_all : p_or_d_all,
            p_or_d : p_or_d
        };
                    
    }]);
})(angular, oleApp);

