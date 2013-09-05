describe 'Controller: TreemapCtrl', () ->

  # load the controller's module
  beforeEach module 'fgvApp'

  TreemapCtrl = {}
  scope = {}
  state = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, $state) ->
    scope = $rootScope.$new()
    state = $state
    TreemapCtrl = $controller 'TreemapCtrl', {
      $scope: scope
      $state: state
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
