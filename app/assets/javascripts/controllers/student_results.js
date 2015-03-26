(function(angular, app) {
    "use strict";
    app.controller("StudentResultController",["$scope", "examService", "resultService", "$window", function($scope, examService, resultService, $window) {
        $scope.scheduleDateFrom = "";
        $scope.scheduleDateTo = "";
        $scope.getExams = function(){
            examService.getUserExams()
                .then(function(responce){
                    $scope.exams = responce.data;
                });
        };
        
        $scope.getSchedules = function(){
            examService.getExamGroupedSchedules($scope.examId)
                .then(function(responce){
                    $scope.schedules = responce.data
                });
        };

        $scope.page = 1 
        $scope.getResults = function(){
            resultService.examResults($scope.examId, $scope.scheduleDateFrom, $scope.scheduleDateTo, $scope.page)
                .then(function(responce){
                    $scope.results = responce.data.results
                    $scope.total_entries = responce.data.total_entries;
                    $scope.current_page = parseInt(responce.data.current_page)
                    $scope.to_index = responce.data.to_index 
                    $scope.from_index = responce.data.from_index
                    if($scope.results.length < 1){
                        $scope.noData = true
                    }else{
                        $scope.noData = false
                    }
                });
        }

        $scope.searchOnStudent = function(){
            resultService.searchOnStudent($scope.examId, $scope.scheduleDateFrom, $scope.scheduleDateTo, $("#studentId").val())
                .then(function(responce){
                    $scope.results = responce.data.results
                });
        }

        $scope.print = function(){
            $window.open(resultService.printUrl($scope.examId, $scope.scheduleDateFrom, $scope.scheduleDateTo), "_blank")
        }

        $scope.composeMail = function(){
            $scope.mailTemplate = {email: "", subject: "", content: "", exam_id: $scope.examId, schedule_date_from: $scope.scheduleDateFrom, schedule_date_to: $scope.scheduleDateTo}
            $("#mailModal").modal()
        }

        $scope.mail = function(){
            $scope.mailTemplate.email = $("#email").val()
            resultService.mail($scope.mailTemplate)
                .then(function(data){
                    alert("Mail Submitted Successfully!")
                    $("#mailModal").modal('hide');
                })
        }

        $scope.nextPage = function(){
            $scope.page = $scope.current_page + 1;
            $scope.getResults();
        }
        
        $scope.previousPage = function(){
            $scope.page = $scope.current_page - 1 ;
            $scope.getResults();
        }
        

        
    }]);
})(angular, oleApp);
