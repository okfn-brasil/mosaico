angular.module('fgvApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/treemap',
        templateUrl: 'views/treemap.html'
        controller: 'TreemapCtrl'
      .otherwise
        redirectTo: '/'
