describe 'Directive: years', () ->

  beforeEach module 'fgvApp', 'views/partials/years.html'

  scope = {}
  element = {}

  beforeEach inject ($compile, $rootScope, openspending) ->
    response =
      data:
        drilldown: [
          { year: '2011' }
          { year: '2010' }
        ]
    spyOn(openspending, 'aggregate').andReturn(then:((callback) -> callback(response)))
    scope = $rootScope
    element = angular.element '<years year="year" years="years" cuts="cuts"></years>'
    element = $compile(element) scope

  it 'should loads the available years, sorted, considering the cuts, ignoring cuts.year', inject (openspending) ->
    scope.cuts =
      year: 2011
      funcao: 10
    scope.$digest()
    expect(scope.years).toEqual ['2010', '2011']
    expect(openspending.aggregate).toHaveBeenCalledWith({funcao: 10}, ['year'])

  it 'should set the year to the latest available, if none was set', ->
    scope.cuts = {}
    scope.$digest()
    expect(scope.year).toEqual '2011'

  it 'should set the year to the latest available, if scope.year isn\'t available', ->
    scope.year = 2156
    scope.$digest()
    expect(scope.year).toEqual '2011'
