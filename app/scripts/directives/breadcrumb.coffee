angular.module('fgvApp').directive 'breadcrumb', ($state, routing) ->
  restrict: 'E',
  templateUrl: '/views/partials/breadcrumb.html'
  link: (scope, element, attributes) ->
    setupBreadcrumbUrls = (breadcrumb) ->
      for element in breadcrumb
        element.url = routing.href(element)

      scope.breadcrumb = breadcrumb

      $('#treemap_breadcrumb > li > span.atLevel').tipsy({clsStyle: 'breadcrumb', gravity: 's', opacity: '1'})

    scope.$watch routing.getBreadcrumb, setupBreadcrumbUrls, true
