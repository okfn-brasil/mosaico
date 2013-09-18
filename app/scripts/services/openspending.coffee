angular.module('fgvApp').factory 'openspending', ($http, $q) ->
  url = 'http://openspending.org'
  dataset = 'orcamento_publico'

  apiUrl = "#{url}/api/2"
  aggregateUrl = "#{apiUrl}/aggregate"

  downloadUrl = (cuts, drilldowns, measures) ->
    params = ["dataset=#{dataset}",
              "format=csv"]
    if cuts
      cutsParams = ("#{k}:#{v}" for own k, v of cuts)
      params.push "cut=#{cutsParams.join('|')}"
    if drilldowns
      params.push "drilldown=#{drilldowns.join('|')}"
    if measures
      params.push "measure=#{measures.join('|')}"
    "#{aggregateUrl}?#{params.join('&')}"


  aggregate = (cuts, drilldowns) ->
    cutsParams = ("#{k}:#{v}" for own k, v of cuts)
    parameters =
      dataset: dataset
      cut: cutsParams.join('|')
      drilldown: drilldowns.join('|')

    $http.jsonp("#{aggregateUrl}?callback=JSON_CALLBACK", params: parameters)

  url: url
  downloadUrl: downloadUrl
  dataset: dataset
  aggregate: aggregate
