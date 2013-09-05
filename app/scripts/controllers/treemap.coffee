angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state) ->
    $scope.year = 2013
    $scope.state = $state
    # FIXME: Here we're considering that $state.params is sorted, which we
    # can't guarantee, as it's a hash (unordered by design)
    $scope.breadcrumb = ({taxonomy: cut, id: parseInt(value)} for own cut, value of $state.params)

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

