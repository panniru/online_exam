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
        
        return {
            resultInDetail : resultInDetail,
            updateResultDetails : updateResultDetails
        };
                    
    }]);
})(angular, oleApp);

