(function(angular, app) {
    "use strict";
    app.service("resultService",["$http", function($http) {
        var resultInDetail = function(resultId){
            var url = "/results/"+resultId+"/result_in_detail.json"
            return $http.get(url);
        }
        
        var updateResultDetails = function(resultId, details){
            var url = "/results/"+resultId+"/update_result_details.json"
            return $http.put(url, {schedule_details: details})
        }

        var examResults = function(examId, date_from, date_to, page){
            var url = "/results/exam_results.json"
            return $http.get(url, {params:{exam_id: examId, schedule_date_from: date_from, schedule_date_to: date_to, page:page}});
        }

        var searchOnStudent = function(examId, date_from, date_to, studentId){
            var url = "/results/exam_results.json"
            return $http.get(url, {params:{exam_id: examId, schedule_date_from: date_from, schedule_date_to: date_to, student_id: studentId}});
        }

        var printUrl = function(examId, date_from, date_to){
            return "/results/exam_results.pdf?exam_id="+examId+"&schedule_date_from="+date_from+"&schedule_date_to="+date_to
        }

        var mail = function(formData){
            var url = "/results/mail.json"
            return $http.get(url, {params: formData});
        }
        
        return {
            resultInDetail : resultInDetail,
            updateResultDetails : updateResultDetails,
            examResults : examResults,
            searchOnStudent : searchOnStudent,
            printUrl : printUrl,
            mail : mail
        };
                    
    }]);
})(angular, oleApp);

