angular.module('fgvApp')
  .controller 'HomeCtrl', ($scope) ->
    $scope.year = 2013
    $scope.entity = {
      type: 'orgao'
      id: 2600
    }
    $scope.active = true
