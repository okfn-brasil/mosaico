angular.module('fgvApp', ['ui.router', 'ngSocial'])
  .constant('_START_REQUEST_', '_START_REQUEST_')
  .constant('_END_REQUEST_', '_END_REQUEST_')
  .constant('_FAILED_REQUEST_', '_FAILED_REQUEST_')
  .run ($rootScope, $state) ->
    $rootScope.$state = $state
  .config ($locationProvider, $stateProvider, $urlRouterProvider, $httpProvider) ->
    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'root',
        url: '/'
        templateUrl: '/views/home.html'
        controller: 'HomeCtrl'
      .state 'about',
        url: '/sobre'
        templateUrl: '/views/about.html'
      .state 'contact',
        url: '/contato'
        templateUrl: '/views/contact.html'
      .state '404',
        url: '/404'
        templateUrl: '/views/404.html'
      .state 'treemap',
        url: '/treemap'
        templateUrl: '/views/treemap.html'
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

    $urlRouterProvider
      .when('', '/')
      .otherwise('/404')

    interceptor = ['_START_REQUEST_', '_END_REQUEST_', '_FAILED_REQUEST_', '$q', '$injector', (_START_REQUEST_, _END_REQUEST_, _FAILED_REQUEST_, $q, $injector) ->
      $rootScope = $injector.get('$rootScope')
      $http = undefined

      success = (response) ->
        $http ||= $injector.get('$http')
        if $http.pendingRequests.length < 1
          $rootScope.$broadcast(_END_REQUEST_)
        response

      error = (response) ->
        response = success(response)
        $rootScope.$broadcast(_FAILED_REQUEST_)
        $q.reject(response)

      (promise) ->
        $rootScope.$broadcast(_START_REQUEST_)
        promise.then(success, error)
     ]

     $httpProvider.responseInterceptors.push(interceptor)
