angular.module('fgvApp', ['ui.router'])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state 'root',
        url: '/'
        templateUrl: 'views/home.html'
        controller: 'HomeCtrl'
      .state 'treemap',
        url: '/treemap'
        templateUrl: 'views/treemap.html'
        controller: 'TreemapCtrl'
