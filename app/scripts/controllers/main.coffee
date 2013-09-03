'use strict'

angular.module('fgvApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    $scope.year = 2013
    $scope.entity = {
      type: 'orgao'
      id: 2600
    }
    $scope.active = true
