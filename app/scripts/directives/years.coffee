angular.module('fgvApp').directive 'years', (openspending) ->
  templateUrl: 'views/partials/years.html'
  restrict: 'E'
  scope:
    year: '='
    years: '='
    cuts: '='
  link: (scope, element, attrs) ->
    loadAvailableYears = (cuts) ->
      cutsCopy = ({type: key, id: val} for own key, val of cuts when key isnt 'year')
      openspending.aggregate(cutsCopy, ['year']).then (response) ->
        years = (d.year for d in response.data.drilldown)
        scope.years = years.sort()
        if !scope.year || !(scope.year in scope.years)
          scope.year = scope.years[scope.years.length-1]

    scope.$watch 'cuts', loadAvailableYears, true
