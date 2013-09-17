angular.module('fgvApp').directive 'breadcrumb', ($state, routing) ->
  restrict: 'E',
  templateUrl: 'views/partials/breadcrumb.html'
  link: (scope, element, attributes) ->
    setupBreadcrumbUrls = (breadcrumb) ->
      breadcrumbWithoutYear = (b for b in breadcrumb when b.type isnt 'year')
      for element in breadcrumbWithoutYear
        element.url = routing.href(element)

      scope.breadcrumb = breadcrumbWithoutYear

    scope.$watch routing.getBreadcrumb, setupBreadcrumbUrls, true
