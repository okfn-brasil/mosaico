angular.module('fgvApp', ['ui.router', 'ngSocial', 'nvd3ChartDirectives'])
  .constant('_START_REQUEST_', '_START_REQUEST_')
  .constant('_END_REQUEST_', '_END_REQUEST_')
  .constant('_FAILED_REQUEST_', '_FAILED_REQUEST_')
  .run ($rootScope, $state, $location) ->
    $rootScope.$state = $state
    console.log "PATH", $location.path()
    $rootScope.location = $location;
  .config ($locationProvider, $stateProvider, $urlRouterProvider, $httpProvider) ->
    $locationProvider.html5Mode(true)

    $stateProvider
      .state '404',
        url: '/404'
        templateUrl: '/views/404.html'
      .state 'start',
        url: '/'
        templateUrl: '/views/start.html'
      .state 'about',
        url: '/sobre'
        templateUrl: '/views/about.html'
      .state 'treemap',
        url: '/mosaico'
        templateUrl: '/views/treemap.html'
        controller: 'TreemapCtrl'
        abstract: true
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

    currentYear = '2013'

    $urlRouterProvider
       .when('/mosaico', "/mosaico/#{currentYear}")
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
