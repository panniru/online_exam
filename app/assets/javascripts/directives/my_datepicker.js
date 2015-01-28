(function(angular, app) {
    "use strict";
    app.directive("myDatepicker", ['$timeout', function($timeout){
        return {
            restrict: 'A',
            require: 'ngModel',
            link: function(scope, elem, attrs, ngModel){
                // timeout internals are called once directive rendering is complete
                $timeout(function(){                    
                    $(elem).datepicker({
                        dateFormat: 'dd-mm-yy',
                        onSelect: function (dateText, inst) {
                            ngModel.$setViewValue(dateText);
                            ngModel.$render();
                        }
                    });
                });
            }
        };
    }]);
})(angular, oleApp);
