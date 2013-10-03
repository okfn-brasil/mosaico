describe 'Service: choroplethScale', ->
  beforeEach module 'fgvApp'

  response = {}
  cuts = {}
  drilldown = ''
  measures = {}

  beforeEach inject (openspending) ->
    cuts = {}
    drilldown = 'funcao'
    measures = ['amount', 'pago', 'rppago']
    response =
      data:
        drilldown: [
          {
            funcao: { name: 'SAUDE' }
            amount: 1000
            pago: 200
            rppago: 300
          }
          {
            funcao: { name: 'EDUCACAO' }
            amount: 2000
            pago: 1000
            rppago: 1000
          }
        ]
    spyOn(openspending, 'aggregate').andReturn(then:((callback) -> callback(response)))

  it 'should exist', inject (choroplethScale) ->
    expect(choroplethScale).not.toBe null

  it 'should return a scale object with the expected methods', inject ($rootScope, openspending, choroplethScale) ->
    expectedMethods = ['classNameFor']
    choroplethScale.get(cuts, drilldown, measures).then (scale) ->
      expect(scale).not.toBe null
      expect(Object.keys(scale)).toEqual expectedMethods
    $rootScope.$apply()

  it 'should return the correct class names for the nodes', inject ($rootScope, choroplethScale) ->
    expectedValues = [
      {
        class: 'red',
        node: { data: { name: 'SAUDE' } }
      }
      {
        class: 'blue',
        node: { data: { name: 'EDUCACAO' } }
      }
    ]
    choroplethScale.get(cuts, drilldown, measures).then (scale) ->
      for value in expectedValues
        expect(scale.classNameFor(value.node)).toBe value.class
    $rootScope.$apply()
