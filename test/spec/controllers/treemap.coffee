describe 'Controller: TreemapCtrl', ->

  # load the controller's module
  beforeEach module 'fgvApp'

  TreemapCtrl = {}
  scope = {}
  state = {}
  routingService = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, $state, routing) ->
    scope = $rootScope.$new()
    state = $state
    routingService = routing
    TreemapCtrl = $controller 'TreemapCtrl', {
      $scope: scope
      $state: state
      routing: routingService
    }

  it 'should add the state to the scope', ->
    expect(scope.state).toBe state

  it 'should pop a state from the breadcrumb when going back', ->
    scope.breadcrumb = ['funcao', 'subfuncao']
    scope.back()
    expect(scope.breadcrumb.length).toBe 1
    expect(scope.breadcrumb[0]).toBe 'funcao'

  it 'should add the current year in scope.year', ->
    current_year = new Date().getFullYear()
    expect(scope.year).toBe current_year

  it 'should redirect to scope.year if no year was passed', inject ($controller) ->
    spyOn(state, 'go')
    $controller 'TreemapCtrl', {
      $scope: scope
      $state: state
      routing: routingService
    }
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
    }
    expect(scope.breadcrumb.length).toBe 1
    expect(scope.breadcrumb[0].type).toBe 'funcao'

  it 'should add the year to the params to scope.go', ->
    spyOn(state, 'go')
    scope.year = 2012
    scope.breadcrumb = [
      { type: 'funcao', id: 432 }
    ]
    scope.$digest()
    expect(state.go).toHaveBeenCalledWith('treemap.year.funcao', { year: 2012, funcao: 432 })

  it 'should convert params\' values to integer when adding them to cuts', ->
    state.params = funcao: '123'
    scope.$emit('$stateChangeSuccess')
    expect(Object.keys(scope.cuts).length).toBe 1
    expect(scope.cuts.funcao).toBe 123
