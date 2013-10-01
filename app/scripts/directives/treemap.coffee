angular.module('fgvApp').directive 'treemap', (openspending) ->
  colorize = (data) ->
    for node in data.children
      node.data.$color = '#1C2F67'

  onClick = ((tile) ->)

  hasClick = ((tile) -> true)

  watchDrilldowns = (treemap, scope) ->
    drilldown = treemap.context.drilldown
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        onClick(tile)
        drilldown(tile)

  buildGraph = (element, drilldowns, cuts, scope) ->
    state =
      drilldowns: drilldowns
      cuts: cuts
    context =
      dataset: openspending.dataset
      siteUrl: openspending.url
      embed: true
      click: (tile) -> # Não redireciona pro OpenSpending
      hasClick: hasClick
      colorize: colorize

    deferred = new window.OpenSpending.Treemap(element, context, state)
    deferred.done (treemap) -> watchDrilldowns(treemap, scope)
    deferred

  restrict: 'E',
  scope:
    cuts: '='
    click: '='
    drilldown: '='
  templateUrl: 'views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = '.'
    window.OpenSpending.localeDecimalSeparator = ','

    treemapElem = element.children('div')
    onClick = scope.click if scope.click?

    hasClick = (tile) ->
      tile.data.node.taxonomy != attributes.lastDrilldown

    scope.$watch('cuts + drilldown', (->
      cuts = scope.cuts
      drilldown = scope.drilldown
      return unless cuts and drilldown

      buildGraph(treemapElem, [drilldown], cuts, scope)
    ), true)

