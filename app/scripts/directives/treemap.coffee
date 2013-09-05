angular.module('fgvApp').directive 'treemap', (openspending) ->
  getColorPalette = (num) ->
    ('#1C2F67' for i in [0...num])

  buildCurrentTile = (treemap, tile) ->
    id: parseInt(tile.data.name)
    label: tile.name
    type: tile.data.node.taxonomy

  watchDrilldowns = (treemap, scope) ->
    drilldown = treemap.context.drilldown
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        lastTile = scope.breadcrumb[scope.breadcrumb.length-1]
        currentTile = buildCurrentTile(treemap, tile)
        currentTitleIsDifferentThanLast = (!lastTile || lastTile.type != currentTile.type)
        if (treemap.context.hasClick(tile) && currentTitleIsDifferentThanLast)
          scope.breadcrumb.push currentTile
        drilldown(tile)

  buildGraph = (element, drilldowns, year, cuts, hasClick, scope) ->
    state =
      drilldowns: drilldowns
      year: year
      cuts: cuts
    context =
      dataset: openspending.dataset
      siteUrl: openspending.url
      embed: true
      click: (node) -> # Não redireciona pro OpenSpending
      hasClick: hasClick

    deferred = new window.OpenSpending.Treemap(element, context, state)
    deferred.done (treemap) -> watchDrilldowns(treemap, scope)
    deferred

  restrict: 'E',
  scope:
    year: '='
    breadcrumb: '='
    cuts: '='
  templateUrl: 'views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = attributes.drilldowns.split('|')
    treemapElem = element.children('div')

    scope.$watch('cuts',( (cuts) ->
      cuts = scope.cuts
      year = cuts.year
      possibleDrilldowns = (d for d in drilldowns when d not in Object.keys(cuts))
      currentDrilldown = [possibleDrilldowns[0]]
      return unless year

      lastDrilldown = drilldowns[drilldowns.length-1]
      hasClick = (node) ->
        node.data.node.taxonomy != lastDrilldown

      buildGraph(treemapElem, currentDrilldown, year, cuts, hasClick, scope)
    ), true)

