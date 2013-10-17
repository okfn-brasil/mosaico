describe 'Routes', ->
  beforeEach module 'fgvApp'

  describe 'States', ->
    TREEMAP_STATES = ['404',
                      'treemap',
                      'treemap.year',
                      'treemap.year.funcao',
                      'treemap.year.funcao.subfuncao',
                      'treemap.year.funcao.subfuncao.orgao',
                      'treemap.year.funcao.subfuncao.orgao.uo',
                      'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic']
    for stateName in TREEMAP_STATES
      it "should have a #{stateName} state", inject ($state) ->
        expect($state.get(stateName)).toNotBe null

  describe 'Redirections', ->
    it 'should redirect empty path to root', inject ($rootScope, $location) ->
      $location.path('')
      $rootScope.$emit('$locationChangeSuccess')
      expect($location.path()).toBe '/treemap'

    it 'should redirect treemap state to treemap.year with current year', inject ($rootScope, $location) ->
      currentYear = new Date().getFullYear()
      $location.path('/treemap')
      $rootScope.$emit('$locationChangeSuccess')
      expect($location.path()).toBe "/treemap/#{currentYear}"

    it 'should redirect inexistent paths to 404', inject ($rootScope, $location) ->
      $location.path('some-inexistent-path')
      $rootScope.$emit('$locationChangeSuccess')
      expect($location.path()).toBe '/404'

