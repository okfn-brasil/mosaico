describe 'Service: openspending', ->
  beforeEach module 'fgvApp'

  it 'should have a openspending service', inject (openspending) ->
    expect(openspending).toNotBe null

  it 'should expose the openspending url', inject (openspending) ->
    expect(openspending.url).toNotBe null

  it 'should expose the dataset name', inject (openspending) ->
    expect(openspending.dataset).toNotBe null

  describe 'downloadUrl', ->
    it 'should return the full download url', inject (openspending) ->
      url = openspending.downloadUrl()
      expect(url).toMatch "dataset=#{openspending.dataset}"
      expect(url).toMatch /format=csv/

    it 'should return the contextual download url', inject (openspending) ->
      cuts =
        year: 2012
        funcao: 10
      drilldowns = ['year', 'funcao']
      measures = ['pago', 'rppago']
      url = openspending.downloadUrl(cuts, drilldowns, measures)
      expect(url).toMatch /year:2012/
      expect(url).toMatch /funcao:10/
      expect(url).toMatch /drilldown=year|funcao/
      expect(url).toMatch /measure=pago|rppago/

  describe 'aggregate', ->
    it 'should call openspending with the correct params', inject ($http, openspending) ->
      spyOn($http, 'jsonp')
      cuts =
        funcao: 10
        subfuncao: 301
      drilldowns = ['funcao', 'subfuncao']
      params =
        params:
          dataset: openspending.dataset
          cut: 'funcao:10|subfuncao:301'
          drilldown: 'funcao|subfuncao'
      openspending.aggregate(cuts, drilldowns)
      expect($http.jsonp).toHaveBeenCalledWith(jasmine.any(String), params)
