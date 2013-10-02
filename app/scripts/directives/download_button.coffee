angular.module('fgvApp').directive 'downloadButton', (openspending) ->
  restrict: 'E',
  scope:
    cuts: '='
  templateUrl: '/views/partials/download_button.html'
  transclude: true
  link: (scope, element, attributes) ->
    drilldowns = attributes.drilldowns.split('|') if attributes.drilldowns
    measures = attributes.measures.split('|') if attributes.measures

    scope.$watch 'cuts', (cuts) ->
      scope.url = openspending.downloadUrl(cuts, drilldowns, measures)
