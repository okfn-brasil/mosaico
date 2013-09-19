angular.module('fgvApp').factory 'openspending', ($http, $q) ->
  url = 'http://openspending.org'
  dataset = 'orcamento_publico'

  apiUrl = "#{url}/api/2"
  aggregateUrl = "#{apiUrl}/aggregate"

  downloadUrl = (cuts, drilldowns, measures) ->
    params = _buildParams(cuts, drilldowns, measures)
    params.format = 'csv'
    params.pagesize = '1000000000'

    paramsForUrl = ("#{k}=#{v}" for own k, v of params)
    "#{aggregateUrl}?#{paramsForUrl.join('&')}"

  aggregate = (cuts, drilldowns, measures) ->
    parameters = _buildParams(cuts, drilldowns, measures)
    $http.jsonp("#{aggregateUrl}?callback=JSON_CALLBACK", params: parameters)

  _buildParams = (cuts, drilldowns, measures) ->
    parameters =
      dataset: dataset
    if cuts
      cutsParams = ("#{k}:#{v}" for own k, v of cuts)
      parameters.cut = cutsParams.join('|')
    if drilldowns
      parameters.drilldown = drilldowns.join('|')
    if measures
      parameters.measure = measures.join('|')

    parameters

  url: url
  downloadUrl: downloadUrl
  dataset: dataset
  aggregate: aggregate
