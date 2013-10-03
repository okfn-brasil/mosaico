angular.module('fgvApp').factory 'choroplethScale', ($q, openspending) ->
  scale = (choropleth) ->
    classNameFor = (node) ->
      percentualExecutado = choropleth[node.data.name]
      switch
        when percentualExecutado < 0.60 then 'red'
        else 'blue'

    classNameFor: classNameFor

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
      deferred.resolve(scale(choropleth))

    deferred.promise

  get: get
