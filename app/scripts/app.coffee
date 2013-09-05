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
      .state 'treemap.funcao',
        # FIXME: This catches routes like '/treemap/', which leave funcao as
        # "", and breaks our code
        url: '/:funcao'
      .state 'treemap.funcao.subfuncao',
        url: '/:subfuncao'
      .state 'treemap.funcao.subfuncao.orgao',
        url: '/:orgao'
      .state 'treemap.funcao.subfuncao.orgao.uo',
        url: '/:uo'
      .state 'treemap.funcao.subfuncao.orgao.uo.mod_aplic',
        url: '/:mod_aplic'
      .state 'treemap.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa',
        url: '/:elemento_despesa'
