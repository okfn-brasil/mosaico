angular.module('fgvApp').directive 'breadcrumb', ($state, routing) ->
  restrict: 'E',
  templateUrl: '/views/partials/breadcrumb.html'
  link: (scope, element, attributes) ->
    setupBreadcrumbUrls = (breadcrumb) ->
      for element in breadcrumb
        element.url = routing.href(element)

      scope.breadcrumb = breadcrumb

    scope.$watch routing.getBreadcrumb, setupBreadcrumbUrls, true
