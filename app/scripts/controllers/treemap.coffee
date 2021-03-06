angular.module('fgvApp')
  .controller 'TreemapCtrl', ($scope, routing) ->
    drilldowns = ['funcao', 'subfuncao', 'orgao', 'uo', 'mod_aplic', 'elemento_despesa']

    $scope.back = routing.back

    $scope.treemapOnClick = (tile) ->
      drilldown =
        id: parseInt(tile.data.name)
        label: tile.name
        type: tile.data.node.taxonomy
      lastDrilldownType = drilldowns[drilldowns.length - 1]
      if drilldown.type != lastDrilldownType
        routing.updateState(drilldown)

    $scope.$watch 'year', (year) ->
      drilldown =
        id: year
        type: 'year'
      routing.updateState(drilldown) if drilldown.id

    _updateYear = (breadcrumb) ->
      breadcrumbYear = breadcrumb[0]
      $scope.year = breadcrumbYear.id.toString() if breadcrumbYear

    _updateCuts = (breadcrumb) ->
      cuts = {}
      for own _, cut of breadcrumb
        cuts[cut.type] = parseInt(cut.id)
      $scope.cuts = cuts

    _updateCurrentDrilldown = (breadcrumb) ->
      previousDrilldown = breadcrumb[breadcrumb.length - 1].type
      currentIndex = drilldowns.indexOf(previousDrilldown) + 1
      $scope.currentDrilldown = drilldowns[currentIndex]

    _updateYearCuts = (breadcrumb) ->
      yearBreadcrumb = breadcrumb[0]
      $scope.yearCut =
        year: yearBreadcrumb.id

    _update = (breadcrumb) ->
      return unless breadcrumb.length
      _updateYear(breadcrumb)
      _updateCuts(breadcrumb)
      _updateCurrentDrilldown(breadcrumb)
      _updateYearCuts(breadcrumb)

    $scope.$watch routing.getBreadcrumb, _update, true
