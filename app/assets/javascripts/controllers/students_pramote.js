(function(angular, app) {
    "use strict";
    app.controller("StudentsPramoteController",["$scope", "studentService", function($scope, studentService) {
        $scope.page = 1 
        $scope.getStudents = function(){
            studentService.getStudents($scope.course, $scope.semester, $scope.page)
            .then(function(responce){
                $scope.students = responce.data.students
                $scope.total_entries = responce.data.total_entries;
                $scope.current_page = parseInt(responce.data.current_page)
                $scope.to_index = responce.data.to_index 
                $scope.from_index = responce.data.from_index
                $.each($scope.students, function(index, val){
                    val["isChecked"] = false
                });
                $scope.allChecked = false;
            });
        }
        $scope.checkAll = function(){
            $.each($scope.students, function(index, val){
                val.isChecked = $scope.allChecked
            });
        };
        $scope.nextPage = function(){
            $scope.page = $scope.current_page + 1;
            $scope.getStudents();
        }
        
        $scope.previousPage = function(){
            $scope.page = $scope.current_page - 1 ;
            $scope.getStudents();
        }
        
        $scope.p_or_d_all = function(action){
            studentService.p_or_d_all($scope.course, $scope.semester, action)
                .then(function(responce){
                    if(responce.data > 0){
                        $scope.getStudents();
                    }
                });
        }

        $scope.p_or_d = function(action){
            var students = []
            $.each($scope.students, function(index, val){
                if(val.isChecked){
                    students.push({id: val.id})
                }
            });
            studentService.p_or_d(students, action, $scope.semester)
                .then(function(responce){
                    if(responce.data > 0){
                        $scope.getStudents();
                    }
                    
                });
        }
    }]);
})(angular, oleApp);
