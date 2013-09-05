angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state, routing) ->
    _loadYear = (state) ->
      default_year = new Date().getFullYear()
      if not state.params.year
        $state.go('treemap.year', year: default_year)
      state.params.year || default_year

    $scope.back = ->
      $scope.breadcrumb.pop()

    updateState = (breadcrumb) ->
      params = [{
        type: 'year'
        id: $scope.year
      }]
      params = params.concat(breadcrumb)
      routing.updateState('treemap', params, $state)
    $scope.$watch('breadcrumb', updateState, true)

    $scope.$on '$stateChangeSuccess', ->
      cuts = {}
      for own cut, value of $state.params
        cuts[cut] = parseInt(value)
      $scope.cuts = cuts

    $scope.year = _loadYear($state)
    $scope.state = $state
    $scope.breadcrumb = routing.loadParamsInOrder($state).filter (param) ->
      param.type != 'year'

