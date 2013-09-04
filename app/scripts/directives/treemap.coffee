angular.module('fgvApp').directive 'treemap', ['openspending', (openspending) ->
  getColorPalette = (num) ->
    ('#3498db' for i in [0...num])

  buildCurrentNode = (treemap, tile) ->
    id: tile.data.name
    label: tile.name
    taxonomy: tile.data.node.taxonomy
    amount: treemap.total
    children: (child.data.node for child in treemap.data.children)

  watchDrilldowns = (treemap, scope) ->
    scope.breadcrumb = []
    scope.back = ->
      if (scope.breadcrumb && scope.breadcrumb.length > 0)
        treemap.setNode(scope.breadcrumb.pop())

    drilldown = treemap.context.drilldown
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        if treemap.context.hasClick(tile)
          scope.breadcrumb.push buildCurrentNode(treemap, tile)
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
    breadcrumb: '='
  templateUrl: 'views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = attributes.drilldowns.split('|')
    treemapElem = element.children('div')

    scope.$watch 'year', (year) ->
      entity = undefined # Não precisamos de uma entidade ainda
      buildGraph(treemapElem, drilldowns, year, entity, scope)
]

