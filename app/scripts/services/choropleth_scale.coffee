angular.module('fgvApp').factory 'choroplethScale', ($q, openspending) ->
  _classNameFor = (choropleth) ->
    (node) ->
      percentualExecutado = choropleth[node.data.name]
      switch
        when percentualExecutado < 0.60 then 'red'
        else 'blue'

  get = (cuts, drilldown, measures) ->
    deferred = $q.defer()

    openspending.aggregate(cuts, [drilldown], measures).then (response) ->
      choropleth = {}
      for d in response.data.drilldown
        name = d[drilldown].name
        autorizado = d.amount
        executado = d.pago + d.rppago
        percentualExecutado = executado/autorizado
        choropleth[name] = percentualExecutado
      deferred.resolve(_classNameFor(choropleth))

    deferred.promise

  get: get
