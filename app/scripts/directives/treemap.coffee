angular.module('fgvApp').directive 'treemap', ($q, openspending) ->
  _choropleth = undefined

  classNameFor = (node) ->
    percentualExecutado = _choropleth[node.data.name]
    switch
      when percentualExecutado < 0.60 then 'red'
      else 'blue'

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

  initChoropleth = (cuts, drilldown, measures) ->
    deferred = $q.defer()

    openspending.aggregate(cuts, [drilldown], measures).then (response) ->
      choropleth = {}
      for d in response.data.drilldown
        name = d[drilldown].name
        autorizado = d.amount
        executado = d.pago + d.rppago
        percentualExecutado = executado/autorizado
        choropleth[name] = percentualExecutado
      _choropleth = choropleth
      deferred.resolve()

    deferred.promise

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

      initChoropleth(cuts, drilldown, measures).then ->
        buildGraph(treemapElem, [drilldown], cuts, scope)

    scope.$watch 'cuts', (-> update(scope.cuts, scope.drilldown)), true

