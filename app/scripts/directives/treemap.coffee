angular.module('fgvApp').directive 'treemap', (openspending) ->
  getColorPalette = (num) ->
    ('#1C2F67' for i in [0...num])

  onClick = ((tile) ->)

  watchDrilldowns = (treemap, scope) ->
    drilldown = treemap.context.drilldown
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        onClick(tile)
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
    cuts: '='
    click: '='
  templateUrl: 'views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = attributes.drilldowns.split('|')
    treemapElem = element.children('div')
    onClick = scope.click if scope.click?

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

