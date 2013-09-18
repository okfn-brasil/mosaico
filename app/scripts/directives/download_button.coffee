angular.module('fgvApp').directive 'downloadButton', (openspending) ->
  restrict: 'E',
  scope:
    cuts: '='
  templateUrl: 'views/partials/download_button.html'
  link: (scope, element, attributes) ->
    drilldowns = attributes.drilldowns.split('|')
    scope.$watch 'cuts', (cuts) ->
      scope.url = openspending.downloadUrl(cuts, drilldowns)
