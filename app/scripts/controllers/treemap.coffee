angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state) ->
    _loadBreadcrumb = (state) ->
      # We consider that the state name is in the form
      # treemap.funcao.subfuncao...
      taxonomies = state.current.name.split('.')
      taxonomies.shift()
      params = state.params
      ({taxonomy: cut, id: parseInt(params[cut])} for cut in taxonomies)

    $scope.year = 2013
    $scope.state = $state
    $scope.breadcrumb = _loadBreadcrumb($state)
    console.log($scope.breadcrumb)

    $scope.back = ->
      $scope.breadcrumb.pop()

    updateState = (breadcrumb) ->
      taxonomies = ['treemap']
      params = {}
      for b in breadcrumb
        params[b.taxonomy] = b.id
        taxonomies.push b.taxonomy
      state = taxonomies.join('.')
      $state.go(state, params)
    $scope.$watch('breadcrumb', updateState, true)

    $scope.$on '$stateChangeSuccess', ->
      cuts = {}
      for own cut, value of $state.params
        cuts[cut] = parseInt(value)
      $scope.cuts = cuts

