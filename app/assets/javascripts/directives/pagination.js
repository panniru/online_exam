(function(angular, app) {
    "use strict";
    app.directive("myPagination", function() {
        return {
            restrict: 'E',
            scope: {
                from: '=',
                to: '=',
                total: '=',
                action: '&'
            },
            controller: ["$scope", function($scope){
                $scope.current_page = 1;
                $scope.previousPage = function(){
                    $scope.current_page -= 1
                    $scope.action({page: $scope.current_page})
                }
                $scope.nextPage = function(){
                    $scope.current_page += 1
                    $scope.action({page: $scope.current_page})
                }
            }],
            templateUrl: "paginationElements.html"
        }
    });
})(angular, oleApp);
