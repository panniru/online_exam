(function(angular, app) {
    "use strict";
    app.service("examService",["$http", function($http) {
        var getUserExams = function(){
            var url = "/exams.json"
            return $http.get(url);
        }
        
        var getExamGroupedSchedules = function(examId){
            var url = "/exams/"+examId+"/schedules.json"
            return $http.get(url)
        }
        
        return {
            getUserExams : getUserExams,
            getExamGroupedSchedules : getExamGroupedSchedules
        };
                    
    }]);
})(angular, oleApp);

