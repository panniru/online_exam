(function(angular, app) {
    "use strict";
    app.service("paginationService",["$rootScope", function($rootScope) {
        
        var initialize = function(data){
            $rootScope.total_entries = data.total_entries;
            $rootScope.current_page = parseInt(data.current_page)
            $rootScope.to_index = data.to_index 
            $rootScope.from_index = data.from_index
        }

        var getPage = function(){
            return $rootScope.page;
        }

        var nextPage = function(){
            $rootScope.page = $rootScope.current_page + 1;
            $rootScope.delegatePostAction();
        }

        var previousPage = function(){
            $rootScope.page = $rootScope.current_page - 1;
            $rootScope.delegatePostAction();
        }
        
        return {
            initialize : initialize,
            getPage : getPage,
            nextPage : nextPage,
            previousPage : previousPage,
        };
                    
    }]);
})(angular, oleApp);


