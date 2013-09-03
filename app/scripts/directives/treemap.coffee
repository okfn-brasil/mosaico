angular.module('fgvApp').directive 'treemap', ['openspending', (openspending) ->
  getColorPalette = (num) ->
    ('#3498db' for i in [0...num])

  watchDrilldowns = (treemap, scope) ->
    drilldown = treemap.context.drilldown
    scope.drilledDown = false
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        if treemap.context.hasClick(tile)
          scope.drilledDown = true
        drilldown(tile)

  buildGraph = (element, drilldowns, year, entity, scope) ->
    state =
      drilldowns: drilldowns
      year: year
    if entity?
      state.cuts = {}
      state.cuts[entity.type] = entity.id
    context =
      dataset: openspending.dataset
      siteUrl: openspending.url
      embed: true
      click: (node) -> # Não redireciona pro OpenSpending
      hasClick: (node) -> node.data.node.children.length > 0

    deferred = new window.OpenSpending.Treemap(element, context, state)
    deferred.done (treemap) -> watchDrilldowns(treemap, scope)
    deferred

  restrict: 'E',
  scope:
    entity: '='
    year: '='
    active: '='
  templateUrl: 'views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = attributes.drilldowns.split('|')
    treemapElem = element.children('div')

    scope.reset = ->
      entity =
        id: 26000
        type: 'orgao'
      buildGraph(treemapElem, ['orgao', 'uo'], 2013, entity, scope)
      year = scope.year
      if year
        buildGraph(treemapElem, drilldowns, year, scope.entity, scope)

    scope.$watch 'entity.id + year + active', -> scope.reset()
]

