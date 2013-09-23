describe 'Directive: percentualChangeBars', ->

  beforeEach module 'fgvApp', 'views/partials/percentual_change_bars.html'

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

    scope = $rootScope
    element = angular.element '<percentual-change-bars></percentual-change-bars>'
    element = $compile(element) scope
    routing.updateState({ type: 'funcao', id: 10 })

  it 'should gets each year\'s totals', inject ($httpBackend, routing, openspending) ->
    expectedTotals = {
      '2013': 3000
      '2012': 5000
      '2011': 2000
    }
    scope.$digest()
    expect(openspending.aggregate).toHaveBeenCalledWith(undefined, ['year'])
    expect(scope.totals).toEqual expectedTotals

  it 'should set every year value, delta and height for the current cut', inject ($httpBackend, routing, openspending) ->
    expectedBars = [
      { label: '2011', value: 1000, delta: 0, height: 0 }
      { label: '2012', value: 1500, delta: 50, height: 100 }
      { label: '2013', value: 1200, delta: -20, height: 40 }
    ]
    scope.$digest()
    expect(openspending.aggregate).toHaveBeenCalledWith({ funcao: 10 }, ['funcao', 'year'])
    for bar, i in scope.bars
      # Not sure how to avoid it being added, but we can safely ignore it.
      delete bar['$$hashKey']
      expect(bar).toEqual expectedBars[i]

