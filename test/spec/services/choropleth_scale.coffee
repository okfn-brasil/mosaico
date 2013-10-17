describe 'Service: choroplethScale', ->
  beforeEach module 'fgvApp'

  response = {}
  cuts = {}
  drilldown = ''
  measures = {}

  beforeEach inject (openspending) ->
    cuts =
      year: 2010
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

  it 'should return a scale object with the expected attributes', inject ($rootScope, openspending, choroplethScale) ->
    expectedAttributes = ['levels', 'classNameFor']
    choroplethScale.get(cuts, drilldown, measures).then (scale) ->
      expect(scale).not.toBe null
      expect(Object.keys(scale)).toEqual expectedAttributes
    $rootScope.$apply()

  it 'should return the correct class names for the nodes', inject ($rootScope, choroplethScale) ->
    expectedValues = [
      {
        class: 'level-2',
        node: { data: { name: 'SAUDE' } }
      }
      {
        class: 'level-3',
        node: { data: { name: 'EDUCACAO' } }
      }
    ]
    choroplethScale.get(cuts, drilldown, measures).then (scale) ->
      for value in expectedValues
        expect(scale.classNameFor(value.node)).toBe value.class
    $rootScope.$apply()

  describe 'levels', ->
    expectedLevels = []

    beforeEach ->
      expectedLevels = [
        { threshold: 0.5, className: 'level-1' }
        { threshold: 0.8, className: 'level-2' }
        { threshold: Infinity, className: 'level-3' }
      ]

    it 'should return the correct levels', inject ($rootScope, choroplethScale) ->
      choroplethScale.get(cuts, drilldown, measures).then (scale) ->
        expect(scale.levels).toEqual expectedLevels
      $rootScope.$apply()

    it 'should return the correct levels for the current year', inject ($rootScope, choroplethScale) ->
      currentMonth = 9
      currentYear = 2009
      spyOn(Date.prototype, 'getMonth').andReturn(currentMonth)
      spyOn(Date.prototype, 'getFullYear').andReturn(currentYear)
      cuts.year = currentYear
      expectedLevels.map (level) ->
        level.threshold *= currentMonth / 12

      choroplethScale.get(cuts, drilldown, measures).then (scale) ->
        expect(scale.levels).toEqual expectedLevels
      $rootScope.$apply()
