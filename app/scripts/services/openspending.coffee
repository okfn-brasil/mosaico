angular.module('fgvApp').factory 'openspending', ($http, $q) ->
  url = 'http://openspending.org'
  apiUrl = "#{url}/api/2"
  aggregateUrl = "#{apiUrl}/aggregate?callback=JSON_CALLBACK"
  dataset = "orcamento_publico"

  url: url
  dataset: dataset

