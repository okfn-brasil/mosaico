describe 'Directive: years', () ->

  beforeEach module 'fgvApp', '/views/partials/years.html'

  scope = {}
  element = {}
  response = {}

  beforeEach inject ($compile, $rootScope) ->
      response =
        data:
          drilldown: [
            { year: '2011' }
            { year: '2010' }
          ]
      scope = $rootScope
      element = angular.element '<years year="year" years="years" cuts="cuts"></years>'
      element = $compile(element) scope

  it 'should add the cuts to the API call', inject ($httpBackend) ->
    $httpBackend.expectJSONP(/funcao%3A10/).respond(response)
    scope.cuts = funcao: 10
    scope.$digest()

  describe 'openspending mocked', ->
    beforeEach inject (openspending) ->
      spyOn(openspending, 'aggregate').andReturn(then:((callback) -> callback(response)))
  
    it 'should loads the available years, sorted, considering the cuts, ignoring cuts.year', inject (openspending) ->
      scope.year = '2010'
      scope.cuts =
        year: 2010
        funcao: 10
      scope.$digest()
      expect(scope.years).toEqual ['2010', '2011']
      expect(scope.year).toEqual '2010'
      expect(openspending.aggregate).toHaveBeenCalledWith({ funcao: 10 }, ['year'])
  
    it 'should set the year to the latest available, if none was set', ->
      scope.cuts = {}
      scope.$digest()
      expect(scope.year).toEqual '2011'
  
    it 'should set the year to the latest available, if scope.year isn\'t available', ->
      scope.year = '2156'
      scope.$digest()
      expect(scope.year).toEqual '2011'
