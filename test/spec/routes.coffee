describe 'Routes', ->
  beforeEach module 'fgvApp'

  describe 'Root', ->
    it 'should exist', inject ($state) ->
      expect($state.get('root')).toNotBe null

  describe 'Treemap', ->
    TREEMAP_STATES = ['treemap',
                      'treemap.year',
                      'treemap.year.funcao',
                      'treemap.year.funcao.subfuncao',
                      'treemap.year.funcao.subfuncao.orgao',
                      'treemap.year.funcao.subfuncao.orgao.uo',
                      'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic',
                      'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa']
    for stateName in TREEMAP_STATES
      it "should have a #{stateName} state", inject ($state) ->
        expect($state.get(stateName)).toNotBe null

  describe '404', ->
    it 'should exist', inject ($state) ->
      expect($state.get('404')).toNotBe null
