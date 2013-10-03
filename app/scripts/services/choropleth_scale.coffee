angular.module('fgvApp').factory 'choroplethScale', ($q, openspending) ->
  _choropleth = undefined

  classNameFor = (node) ->
    percentualExecutado = _choropleth[node.data.name]
    switch
      when percentualExecutado < 0.60 then 'red'
      else 'blue'

  init = (cuts, drilldown, measures) ->
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

  init: init
  classNameFor: classNameFor
