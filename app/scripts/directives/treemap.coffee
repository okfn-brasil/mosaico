angular.module('fgvApp').directive 'treemap', ($q, choroplethScale, openspending) ->
  getColorPalette = (num) ->
    ('#aaaaaa' for i in [0...num])

  labelFor = (node, currency) ->
    "<div class='desc'><div class='amount'>" +
    OpenSpending.Utils.formatAmountWithCommas(node.data.value, 0, currency) +
    "</div><div class='lbl'>" +
    node.name +
    "</div></div>"

  createLabel = (widget, domElement, node) ->
    domElement.className += " #{classNameFor(node)}"
    shouldCreateLabel = (node.data.value / widget.total) > 0.03
    if shouldCreateLabel
      domElement.innerHTML = labelFor(node, widget.currency)

  classNameFor = ((node) -> '')

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
      createLabel: createLabel

    deferred = new window.OpenSpending.Treemap(element, context, state)
    deferred.done (treemap) -> watchDrilldowns(treemap, scope)
    deferred

  restrict: 'E',
  scope:
    cuts: '='
    click: '='
    drilldown: '='
  templateUrl: '/views/partials/treemap.html'
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = '.'
    window.OpenSpending.localeDecimalSeparator = ','

    treemapElem = element.children('div')
    onClick = scope.click if scope.click?
    measures = attributes.measures.split('|')

    hasClick = (tile) ->
      tile.data.node.taxonomy != attributes.lastDrilldown

    update = (cuts, drilldown) ->
      return unless cuts and drilldown

      choroplethScale.get(cuts, drilldown, measures).then (scale) ->
        classNameFor = scale.classNameFor
        buildGraph(treemapElem, [drilldown], cuts, scope)

    scope.$watch 'cuts', (-> update(scope.cuts, scope.drilldown)), true

