describe 'Controller: TreemapCtrl', ->

  # load the controller's module
  beforeEach module 'fgvApp'

  TreemapCtrl = {}
  scope = {}
  state = {}
  routingService = {}
  breadcrumbService = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, $state, openspending, routing, breadcrumb) ->
    scope = $rootScope.$new()
    state = $state
    routingService = routing
    breadcrumbService = breadcrumb
    spyOn(openspending, 'aggregate').andReturn(then: (->))
    TreemapCtrl = $controller 'TreemapCtrl', {
      $scope: scope
      $state: state
      routing: routingService
      breadcrumb: breadcrumbService
    }

  it 'should pop a state from the breadcrumb when going back', ->
    cut =
      type: 'funcao'
      id: 10
      label: 'SAUDE'
    breadcrumbService.add(cut)
    scope.back()
    expect(breadcrumbService.get()).toNotContain(cut)

  it 'should redirect to scope.year if no year was passed', inject ($controller) ->
    spyOn(state, 'go')
    $controller 'TreemapCtrl', {
      $scope: scope
      $state: state
      routing: routingService
    }
    scope.$digest()
    expect(state.go).toHaveBeenCalledWith('treemap.year', year: scope.year)


  it 'should not add the "year" param in the breadcrumb', inject ($controller) ->
    mockState =
      current:
        name: 'treemap.year.funcao'
      params:
        year: 2011
        funcao: 432
    $controller 'TreemapCtrl', {
      $scope: scope
      $state: mockState
      routing: routingService
      breadcrumb: breadcrumbService
    }
    expect(breadcrumbService.get().length).toBe 1
    expect(breadcrumbService.get()[0].type).toBe 'funcao'

  it 'should add the year to the params to scope.go', ->
    spyOn(state, 'go')
    scope.year = 2012
    breadcrumbService.add {
      type: 'funcao'
      id: 10
      label: 'SAUDE'
    }
    scope.$digest()
    expect(state.go).toHaveBeenCalledWith('treemap.year.funcao', { year: 2012, funcao: '10-saude' })

  it 'should convert params\' values to integer when adding them to cuts', ->
    state.params = funcao: '123'
    scope.$emit('$stateChangeSuccess')
    expect(Object.keys(scope.cuts).length).toBe 1
    expect(scope.cuts.funcao).toBe 123
