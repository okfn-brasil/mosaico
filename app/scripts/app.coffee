angular.module('fgvApp', ['ui.router'])
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')

    $stateProvider
      .state 'root',
        url: '/'
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .state 'treemap',
        url: '/treemap'
        templateUrl: 'views/treemap.html'
        controller: 'TreemapCtrl'
      .state 'treemap.funcao',
        url: '/:funcao'
      .state 'treemap.funcao.subfuncao',
        url: '/:subfuncao'
