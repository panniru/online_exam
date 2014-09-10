(function(angular, app) {
    "use strict";
    app.controller("ExamSearchController",["$scope", "examService", function($scope, examService) {

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
        
    }]);
})(angular, oleApp);
