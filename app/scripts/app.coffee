angular.module('fgvApp', ['ui.router'])
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state 'root',
        url: '/'
        templateUrl: 'views/home.html'
        controller: 'HomeCtrl'
      .state '404',
        url: '/404'
        templateUrl: 'views/404.html'
        controller: 'HomeCtrl'
      .state 'treemap',
        url: '/treemap'
        templateUrl: 'views/treemap.html'
        controller: 'TreemapCtrl'
      .state 'treemap.year',
        url: '/:year'
      .state 'treemap.year.funcao',
        # FIXME: This catches routes like '/treemap/', which leave funcao as
        # "", and breaks our code
        url: '/:funcao'
      .state 'treemap.year.funcao.subfuncao',
        url: '/:subfuncao'
      .state 'treemap.year.funcao.subfuncao.orgao',
        url: '/:orgao'
      .state 'treemap.year.funcao.subfuncao.orgao.uo',
        url: '/:uo'
      .state 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic',
        url: '/:mod_aplic'
      .state 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa',
        url: '/:elemento_despesa'
    $urlRouterProvider
      .when('', '/')
      .otherwise('/404')

