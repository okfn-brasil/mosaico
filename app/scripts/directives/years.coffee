angular.module('fgvApp').directive 'years', (openspending) ->
  templateUrl: '/views/partials/years.html'
  restrict: 'E'
  scope:
    year: '='
    years: '='
    cuts: '='
  link: (scope, element, attrs) ->
    loadAvailableYears = (cuts) ->
      cutsCopy = $.extend({}, cuts)
      delete cutsCopy.year
      openspending.aggregate(cutsCopy, ['year']).then (response) ->
        years = (d.year for d in response.data.drilldown)
        scope.years = years.sort()
        if not scope.year or (scope.year not in scope.years)
          scope.year = scope.years[scope.years.length-1]

    scope.$watch 'cuts', loadAvailableYears, true
