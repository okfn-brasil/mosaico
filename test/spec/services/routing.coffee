describe 'Service: Routing', ->
  beforeEach module 'fgvApp'

  it 'should have a routing service', inject (routing) ->
    expect(routing).toNotBe null

  it 'should initialize the breadcrumb with the current year', inject (routing) ->
    currentYear = new Date().getFullYear()
    year = routing.getBreadcrumb('year')
    expect(year).toBeDefined()
    expect(year.id).toBe currentYear

  it 'should go to the new stating when updating the routing', inject ($state, routing) ->
    spyOn($state, 'go')
    routing.updateState({ type: 'year', id: 2010 })
    expect($state.go).toHaveBeenCalledWith('treemap.year', year: 2010)

  it 'should create a slug for states with labels', inject ($rootScope, $state, routing) ->
    spyOn($state, 'go')
    $rootScope.$digest()
    routing.updateState({ type: 'funcao', id: 10, label: 'SAÚDE' })
    year = routing.getBreadcrumb('year')
    expect($state.go).toHaveBeenCalledWith('treemap.year.funcao',
                                           year: year.id, funcao: '10-saude')

  it 'should not break when receiving invalid params', inject (routing) ->
    routing.updateState({ type: 'invalid-type', id: 51 })

  it 'should go to the previous state when calling back', inject ($state, routing) ->
    spyOn($state, 'go')
    routing.back()
    expect($state.go).toHaveBeenCalledWith('^')

  describe 'getBreadcrumb', ->
    it 'should return just the element if called with key', inject (routing) ->
      expect(routing.getBreadcrumb('year').type).toBe 'year'

    it 'should return everything if key isn\'t a string', inject (routing) ->
      expect($.isArray(routing.getBreadcrumb(some: 'params'))).toBe true

    it 'should return everything if called without key', inject (routing) ->
      expect($.isArray(routing.getBreadcrumb())).toBe true

  describe 'state change', ->
    funcao = {}

    beforeEach inject ($state, $rootScope, openspending, routing) ->
      spyOn(openspending, 'aggregate').andReturn(then: (->))
      $state.current.name = 'treemap.year.funcao'
      $state.params = { year: 2013, funcao: 10 }
      funcao = { type: 'funcao', id: 10, label: 'SAUDE' }
      routing.updateState(funcao)
      $rootScope.$emit '$stateChangeSuccess'

    it 'should not change unmodified states', inject (routing) ->
      expect(routing.getBreadcrumb('funcao')).toBe funcao

    it 'should delete removed states', inject ($state, $rootScope, routing) ->
      $state.current.name = 'treemap.year'
      $state.params = { year: 2013 }
      $rootScope.$emit '$stateChangeSuccess'
      breadcrumb = routing.getBreadcrumb()
      expect(breadcrumb.funcao).toBe undefined

    it 'should add added states', inject ($rootScope, $state, routing) ->
      $state.current.name = 'treemap.year.funcao.subfuncao'
      $state.params = { year: 2013, funcao: 10, subfuncao: 301 }
      $rootScope.$emit '$stateChangeSuccess'
      expect(routing.getBreadcrumb('funcao').id).toEqual 10
      expect(routing.getBreadcrumb('subfuncao').id).toEqual 301

  describe 'breadcrumb labels', ->
    labels = []
    response = {}

    beforeEach inject ($state, openspending) ->
      labels = ['SAUDE', 'ATENCAO BASICA']
      response =
        data:
          drilldown: [
            funcao: { name: '10', label: labels[0] },
            subfuncao: { name: '301', label: labels[1] },
            year: '2011'
          ]
      spyOn(openspending, 'aggregate').andReturn(then: ((callback) -> callback(response)))
      $state.current.name = 'treemap.year.funcao.subfuncao'
      $state.params = { year: 2011, funcao: 10, subfuncao: 301 }

    it 'should get the drilldowns labels from OpenSpending', inject ($rootScope, routing) ->
      $rootScope.$emit '$stateChangeSuccess'
      year = routing.getBreadcrumb('year')
      funcao = routing.getBreadcrumb('funcao')
      subfuncao = routing.getBreadcrumb('subfuncao')
      expect(year.label).not.toBeDefined
      expect(funcao.label).toBe labels[0]
      expect(subfuncao.label).toBe labels[1]

    it 'should get just the ID from the URL, when parsing it', inject ($rootScope, $state, routing) ->
      $state.current.name = 'treemap.year.funcao'
      $state.params.funcao = '10-saude'
      $rootScope.$emit '$stateChangeSuccess'
      funcao = routing.getBreadcrumb('funcao')
      expect(funcao.id).toBe 10

    it 'should not overwrite the breadcrumb if it has changed', inject ($rootScope, $state, routing) ->
      # As we're doing an AJAX request, the user might have changed the state
      # before it completes. In this case, it should just populate what is
      # still valid.
      $state.params.subfuncao = 21
      $rootScope.$emit '$stateChangeSuccess'
      funcao = routing.getBreadcrumb('funcao')
      subfuncao = routing.getBreadcrumb('subfuncao')
      expect(funcao.label).toBe labels[0]
      expect(subfuncao.id).toBe 21
      expect(subfuncao.label).toBe undefined

    it 'should not try to get the label of the year', inject ($rootScope, openspending, routing) ->
      $rootScope.$emit '$stateChangeSuccess'
      breadcrumb = routing.getBreadcrumb()
      expect(openspending.aggregate.mostRecentCall.args[1]).not.toContain 'year'


  describe 'href', ->
    it 'should return the correct element\'s URL', inject (routing) ->
      routing.updateState({ type: 'year', id: 2012 })
      routing.updateState({ type: 'funcao', id: 10, label: 'SAUDE' })

      element = { type: 'subfuncao', id: 301, label: 'ATENCAO BASICA' }
      expect(routing.href(element)).toBe '#/treemap/2012/10-saude/301-atencao-basica'

    it 'should not break if called with invalid element', inject (routing) ->
      element = { type: 'invalid-element', id: 10 }
      routing.href(element)

    it 'should return undefined when trying to get the link of the last state', inject (routing) ->
      element = { type: 'elemento_despesa', id: 10 }
      expect(routing.href(element)).toBe undefined

    it 'should rely on the breadcrumb, not on $state', inject ($state, routing) ->
      $state.current.name = 'treemap.year'
      $state.params = { year: 2013 }
      routing.updateState({ type: 'year', id: 2012 })

      element = { type: 'funcao', id: 10, label: 'SAÚDE' }
      expect(routing.href(element)).toBe '#/treemap/2012/10-saude'
