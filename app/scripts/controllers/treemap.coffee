angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state) ->
    _loadBreadcrumb = (state) ->
      # We consider that the state name is in the form
      # treemap.year.funcao.subfuncao...
      taxonomies = state.current.name.split('.')
      taxonomies.shift() # ignore treemap
      taxonomies.shift() # ignore year
      params = state.params
      ({taxonomy: cut, id: parseInt(params[cut])} for cut in taxonomies)

    _loadYear = (state) ->
      default_year = new Date().getFullYear()
      if not state.params.year
        $state.go('treemap.year', year: default_year)
      state.params.year || default_year

    $scope.back = ->
      $scope.breadcrumb.pop()

    updateState = (breadcrumb) ->
      taxonomies = ['treemap.year']
      params = year: $scope.year
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

    $scope.year = _loadYear($state)
    $scope.state = $state
    $scope.breadcrumb = _loadBreadcrumb($state)

