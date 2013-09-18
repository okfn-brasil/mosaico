describe 'Directive: download_button', ->

  beforeEach module 'fgvApp', 'views/partials/download_button.html'

  scope = {}
  element = {}

  beforeEach inject ($compile, $rootScope) ->
    scope = $rootScope
    element = angular.element '<download-button></download-button>'
    element = $compile(element) scope

  it 'blah', ->
    expect(true).toBe true
