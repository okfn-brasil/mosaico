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
