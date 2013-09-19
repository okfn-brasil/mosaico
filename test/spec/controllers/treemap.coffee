describe 'Controller: TreemapCtrl', ->

  # load the controller's module
  beforeEach module 'fgvApp'

  TreemapCtrl = {}
  scope = {}
  routingService = {}
  breadcrumbService = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, routing) ->
    scope = $rootScope.$new()
    routingService = routing
    TreemapCtrl = $controller 'TreemapCtrl', {
      $scope: scope
      routing: routingService
    }

  it 'should delegate to routing when going back', inject ($state) ->
    # I couldn't make the spy on routing work, so I had to spy on $state
    spyOn($state, 'go')
    scope.back()
    expect($state.go).toHaveBeenCalledWith('^')

  it 'should redirect to scope.year if no year was passed', inject ($controller) ->
    scope.$digest()
    year = routingService.getBreadcrumb('year')
    expect(year).toBeDefined()
    expect(year.id).toBe scope.year

  it 'should keep scope.cuts in sync with the route state', ->
    drilldowns = [
      { id: 2011, type: 'year'}
      { id: 10, type: 'funcao' }
    ]
    routingService.updateState(drilldowns[0])
    routingService.updateState(drilldowns[1])
    scope.$digest()
    expect(Object.keys(scope.cuts).length).toBe 2
    expect(scope.cuts.funcao).toBe 10

  it 'should keep scope.year in sync with the route state', ->
    scope.year = 2009
    scope.$digest()
    year = routingService.getBreadcrumb('year')
    expect(year).toBeDefined()
    expect(year.id).toBe scope.year

  it 'should update the routing state on click on the treemap', ->
    tile =
      name: 'SAUDE'
      data:
        name: '10'
        node:
          taxonomy: 'funcao'
    drilldown =
      id: 10
      label: 'SAUDE'
      type: 'funcao'
    spyOn(routingService, 'updateState')
    scope.treemapOnClick(tile)
    expect(routingService.updateState).toHaveBeenCalledWith(drilldown)

  it 'should not update the routing state when we\'re already on the last drilldown type', ->
    tile =
      name: 'INDENIZACOES E RESTITUICOES'
      data:
        name: '123'
        node:
          taxonomy: 'elemento_despesa'
    spyOn(routingService, 'updateState')
    scope.treemapOnClick(tile)
    expect(routingService.updateState).not.toHaveBeenCalled()

  describe 'currentDrilldown', ->
    it 'should start with the drilldown funcao', ->
      scope.$digest()
      expect(scope.currentDrilldown).toBe 'funcao'

    it 'should update the current drilldown when the state changes', ->
      drilldowns = ['subfuncao', 'orgao', 'uo', 'mod_aplic', 'elemento_despesa']
      for element, i in drilldowns
        currentDrilldown = drilldowns[i+1]
        routingService.updateState({type: element, id: 42})
        scope.$digest()
        expect(scope.currentDrilldown).toBe currentDrilldown
