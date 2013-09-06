angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state, routing, breadcrumb) ->
    $scope.back = ->
      breadcrumb.pop()

    updateState = (breadcrumb) ->
      params = [{
        type: 'year'
        id: $scope.year
      }]
      params = params.concat(breadcrumb)
      routing.updateState('treemap', params, $state)
    $scope.$watch(breadcrumb.get, updateState, true)

    $scope.year = $state.params.year
    $scope.$watch 'year', ->
      updateState(breadcrumb.get())

    $scope.$on '$stateChangeSuccess', ->
      cuts = {}
      for own cut, value of $state.params
        cuts[cut] = parseInt(value)
      $scope.cuts = cuts

    params = routing.loadParamsInOrder($state).filter (param) ->
      param.type != 'year'
    breadcrumb.add params.map (param) ->
      param.id = parseInt(param.id)
      param

