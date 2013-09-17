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

    _updateCuts = (vals) ->
      cuts = {}
      for own _, cut of vals
        cuts[cut.type] = parseInt(cut.id)
      $scope.cuts = cuts

    $scope.$watch routing.getBreadcrumb, _updateCuts, true

