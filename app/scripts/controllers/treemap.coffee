angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, $state, $filter) ->
    $scope.year = 2013
    $scope.state = $state
    $scope.breadcrumb = []

    slug = $filter('slug')
    updateState = (breadcrumb) ->
      taxonomies = ['treemap']
      params = {}
      for b in breadcrumb
        params[b.taxonomy] = "#{b.id}-#{slug(b.label)}"
        taxonomies.push b.taxonomy
      state = taxonomies.join('.')
      $state.go(state, params)

    $scope.$watch('breadcrumb', updateState, true)

