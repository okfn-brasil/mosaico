describe 'Service: Routing', ->
  beforeEach module 'fgvApp'

  it 'should have a routing service', inject (routing) ->
    expect(routing).toNotBe null

  it 'should convert the state.params hash to an ordered array', inject (routing) ->
    mockState =
      current:
        name: 'treemap.year.funcao'
      params:
        year: 2011
        funcao: 432
    result = routing.loadParamsInOrder(mockState)
    expect(result.length).toBe 2
    expect(result[0].type).toBe 'year'
    expect(result[0].id).toBe 2011
    expect(result[1].type).toBe 'funcao'
    expect(result[1].id).toBe 432

  it 'should update to the state depending on the params', inject (routing) ->
    mockState = jasmine.createSpyObj('state', ['go'])
    baseStateName = 'treemap'
    params = [
      { type: 'year', id: 2013 },
      { type: 'funcao', id: 231 }
    ]
    stateParams =
      year: 2013
      funcao: 231
    routing.updateState(baseStateName, params, mockState)
    expect(mockState.go).toHaveBeenCalledWith('treemap.year.funcao', stateParams)
