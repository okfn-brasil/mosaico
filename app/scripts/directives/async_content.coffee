angular.module('fgvApp').directive 'asyncContent', ->
  restrict: 'A',
  link: (scope, element, attributes) ->
    spinner = new Spinner( color: '#2C3E50' )
    cssClass = 'loading'

    scope.$on '_START_REQUEST_', ->
      spinner.spin(element[0])
      element.addClass(cssClass)
      console.log('start request')
    scope.$on '_END_REQUEST_', ->
      spinner.stop()
      element.removeClass(cssClass)
      console.log('end request')
