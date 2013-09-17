describe 'Service: Routing', ->
  beforeEach module 'fgvApp'

  it 'should have a routing service', inject (routing) ->
    expect(routing).toNotBe null

  it 'should initialize the breadcrumb with the current year', inject (routing) ->
    currentYear = new Date().getFullYear()
    breadcrumb = routing.getBreadcrumb()
    expect(breadcrumb).toBeDefined()
    expect(breadcrumb.year.id).toBe currentYear

  it 'should go to the new stating when updating the routing', inject ($state, routing) ->
    spyOn($state, 'go')
    routing.updateState({ type: 'year', id: 2010 })
    expect($state.go).toHaveBeenCalledWith('treemap.year', year: 2010)

  it 'should create a slug for states with labels', inject ($rootScope, $state, routing) ->
    spyOn($state, 'go')
    $rootScope.$digest()
    routing.updateState({ type: 'funcao', id: 10, label: 'SAÚDE' })
    breadcrumb = routing.getBreadcrumb()
    expect($state.go).toHaveBeenCalledWith('treemap.year.funcao',
                                           year: breadcrumb.year.id, funcao: '10-saude')

  it 'should not break when receiving invalid params', inject (routing) ->
    routing.updateState({ type: 'invalid-type', id: 51 })

  it 'should go to the previous state when calling back', inject ($state, routing) ->
    spyOn($state, 'go')
    routing.back()
    expect($state.go).toHaveBeenCalledWith('^')

  it 'should get the drilldowns labels from OpenSpending, ignoring "year"', inject ($rootScope, $state, openspending, routing) ->
    labels = ['SAUDE', 'ATENCAO BASICA']
    response =
      data:
        drilldown: [
          funcao: { label: labels[0] },
          subfuncao: { label: labels[1] },
          year: '2011'
        ]
    spyOn(openspending, 'aggregate').andReturn(then: ((callback) -> callback(response)))
    $state.current.name = 'treemap.year.funcao.subfuncao'
    $state.params = { year: 2011, funcao: 10, subfuncao: 301 }
    $rootScope.$emit '$stateChangeSuccess'
    breadcrumb = routing.getBreadcrumb()
    expect(breadcrumb.year.label).not.toBeDefined
    expect(breadcrumb.funcao.label).toBe labels[0]
    expect(breadcrumb.subfuncao.label).toBe labels[1]

  it 'should get just the ID from the URL, when parsing it', inject ($rootScope, $state, openspending, routing) ->
    spyOn(openspending, 'aggregate').andReturn(then: (->))
    $state.current.name = 'treemap.year.funcao'
    $state.params = { year: '2011', funcao: '10-saude' }
    $rootScope.$emit '$stateChangeSuccess'
    breadcrumb = routing.getBreadcrumb()
    expect(breadcrumb.year.id).toBe 2011
    expect(breadcrumb.funcao.id).toBe 10
