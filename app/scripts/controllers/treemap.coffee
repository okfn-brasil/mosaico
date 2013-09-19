angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, routing) ->
    $scope.back = routing.back

    $scope.treemapOnClick = (tile) ->
      drilldown =
        id: parseInt(tile.data.name)
        label: tile.name
        type: tile.data.node.taxonomy
      lastDrilldownType = 'elemento_despesa'
      if drilldown.type != lastDrilldownType
        routing.updateState(drilldown)

    $scope.year = routing.getBreadcrumb('year').id
    $scope.$watch 'year', (year) ->
      drilldown =
        id: year
        type: 'year'
      routing.updateState(drilldown) if drilldown.id

    _updateCuts = (breadcrumb) ->
      cuts = {}
      for own _, cut of breadcrumb
        cuts[cut.type] = parseInt(cut.id)
      $scope.cuts = cuts

    drilldowns = ['funcao', 'subfuncao', 'orgao', 'uo', 'mod_aplic', 'elemento_despesa']
    _updateCurrentDrilldown = (breadcrumb) ->
      previousDrilldown = breadcrumb[breadcrumb.length - 1].type
      currentIndex = drilldowns.indexOf(previousDrilldown) + 1
      $scope.currentDrilldown = drilldowns[currentIndex]

    _update = (breadcrumb) ->
      _updateCuts(breadcrumb)
      _updateCurrentDrilldown(breadcrumb)

    $scope.$watch routing.getBreadcrumb, _update, true
