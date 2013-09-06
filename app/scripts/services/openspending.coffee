angular.module('fgvApp').factory 'openspending', ($http, $q) ->
  url = 'http://openspending.org'
  dataset = 'orcamento_publico'

  apiUrl = "#{url}/api/2"
  aggregateUrl = "#{apiUrl}/aggregate?callback=JSON_CALLBACK"

  aggregate = (cuts, drilldowns) ->
    cutsParams = ("#{c.type}:#{c.id}" for c in cuts)
    parameters =
      dataset: dataset
      cut: cutsParams.join('|')
      drilldown: drilldowns.join('|')

    $http.jsonp(aggregateUrl, params: parameters)

  url: url
  dataset: dataset
  aggregate: aggregate
