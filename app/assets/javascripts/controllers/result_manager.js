(function(angular, app) {
    "use strict";
    app.controller("ResultManagerController",["$scope", "resultService", function($scope,resultService) {
        $scope.initialize = function(resultId){
            $scope.resultId = resultId;
            resultService.resultInDetail(resultId)
            .then(function(responce){
                $scope.results = responce.data.details;
                $scope.marks_secured = responce.data.marks_secured
                $scope.result_text = responce.data.result_text
            });
        };

        $scope.updateDetails = function(){
            var data = []
            $.each($scope.results, function(index, result){
                data.push({id: result.id, valid_answer: result.valid_answer})
            });
            
            resultService.updateResultDetails($scope.resultId, data)
                .then(function(responce){
                    $scope.marks_secured = responce.data.marks_secured
                    $scope.result_text = responce.data.result_text
                    $scope.editAnswer = false;
                });
        };
        
    }]);
})(angular, oleApp);
