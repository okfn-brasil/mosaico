describe 'Directive: breadcrumb', ->

  beforeEach module 'fgvApp', 'views/partials/breadcrumb.html'

  scope = {}
  element = {}

  beforeEach inject ($compile, $rootScope) ->
    scope = $rootScope
    element = angular.element '<breadcrumb></breadcrumb>'
    element = $compile(element) scope

  it 'should add an href to the breadcrumb\'s elements', inject (routing) ->
    routing.updateState({ type: 'funcao', id: 10 })
    scope.$digest()
    for element in scope.breadcrumb
      expect(element.url).toBe routing.href(element)

  it 'should not add the year to scope.breadcrumb', inject (routing) ->
    routing.updateState({ type: 'year', id: 2011 })
    scope.$digest()
    year = (b for b in scope.breadcrumb when b.type is 'year')[0]
    expect(year).toBe undefined
