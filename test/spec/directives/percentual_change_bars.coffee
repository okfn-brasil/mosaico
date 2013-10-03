describe 'Directive: percentualChangeBars', ->

  beforeEach module 'fgvApp', '/views/partials/percentual_change_bars.html'

  scope = {}
  element = {}
  response = {}
  totals = {}

  beforeEach inject ($compile, $rootScope, routing, openspending) ->
    response =
      data:
        drilldown: [
          { year: '2013', amount: 1200 }
          { year: '2012', amount: 1500 }
          { year: '2011', amount: 1000 }
        ]
    totals =
      data:
        drilldown: [
          { year: '2013', amount: 3000 }
          { year: '2012', amount: 5000 }
          { year: '2011', amount: 2000 }
        ]
        summary:
          amount: 10000
    spyOn(openspending, 'aggregate').andCallFake (cuts, drilldowns) ->
      result = response
      if not cuts and drilldowns.length == 1 and drilldowns[0] == 'year'
        result = totals
      then: (callback) -> callback(result)

    element = angular.element '<percentual-change-bars></percentual-change-bars>'
    element = $compile(element) $rootScope.$new()
    scope = element.scope()
    routing.updateState({ type: 'funcao', id: 10 })

  it 'should gets each year\'s totals', inject ($httpBackend, $rootScope, routing, openspending) ->
    expectedTotals = {
      '2011': 2000
      '2012': 5000
      '2013': 3000
    }
    $rootScope.$digest()
    expect(openspending.aggregate).toHaveBeenCalledWith(undefined, ['year'])
    expect(scope.totals).toEqual expectedTotals

  it 'should set every year value, delta and height for the current cut', inject ($httpBackend, $rootScope, routing, openspending) ->
    expectedBars = [
      { label: '2011', value: 0.5, delta: 0, height: 0 }
      { label: '2012', value: 0.3, delta: -0.4, height: 100 }
      { label: '2013', value: 0.4, delta: 0.3333333333333335, height: 83.33333333333337 }
    ]
    $rootScope.$digest()
    expect(openspending.aggregate).toHaveBeenCalledWith({ funcao: 10 }, ['funcao', 'year'])
    for bar, i in scope.bars
      # Not sure how to avoid it being added, but we can safely ignore it.
      delete bar['$$hashKey']
      expect(bar).toEqual expectedBars[i]

