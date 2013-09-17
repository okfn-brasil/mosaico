angular.module('fgvApp').factory 'routing', ($state, $filter, $rootScope, openspending) ->
  _states = {
    'year': 'treemap.year',
    'funcao.year': 'treemap.year.funcao',
    'funcao.subfuncao.year': 'treemap.year.funcao.subfuncao',
    'funcao.orgao.subfuncao.year': 'treemap.year.funcao.subfuncao.orgao',
    'funcao.orgao.subfuncao.uo.year': 'treemap.year.funcao.subfuncao.orgao.uo',
    'funcao.mod_aplic.orgao.subfuncao.uo.year': 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic',
    'elemento_despesa.funcao.mod_aplic.orgao.subfuncao.uo.year': 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa'
  }
  _typeToStateName = {
    'year': 'treemap.year',
    'funcao': 'treemap.year.funcao',
    'subfuncao': 'treemap.year.funcao.subfuncao',
    'orgao': 'treemap.year.funcao.subfuncao.orgao',
    'uo': 'treemap.year.funcao.subfuncao.orgao.uo',
    'mod_aplic': 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic',
    'elemento_despesa': 'treemap.year.funcao.subfuncao.orgao.uo.mod_aplic.elemento_despesa'
  }
  _breadcrumb = new OrderedHash

  getBreadcrumb = (key) ->
    if key and key in _breadcrumb.keys
      _breadcrumb.val(key)
    else
      _breadcrumb.all()

  href = (element) ->
    stateName = _typeToStateName[element.type]
    params = $.extend({}, $state.params)
    params[element.type] = _slugify(element)
    $state.href(stateName, params) if stateName

  updateState = (params) ->
    _breadcrumb.push(params.type, params) if params?
    new_params = {}
    for _, element of _breadcrumb.vals
      new_params[element.type] = _slugify(element)
    stateName = _stateParamsToStateName(new_params)
    $state.go(stateName, new_params) if stateName?

  back = ->
    $state.go('^')

  _initBreadcrumb = ->
    taxonomies = $state.current.name.split('.')
    params = $state.params
    for key in taxonomies when params[key]
      _breadcrumb.push(key, {type: key, id: parseInt(params[key])})
    _getBreadcrumbLabels()
    if 'year' not in _breadcrumb.keys
      currentYear = new Date().getFullYear()
      _breadcrumb.push('year', {type: 'year', id: currentYear})

  _updateBreadcrumb = ->
    reversedKeys = _breadcrumb.keys.slice().reverse()
    params = $state.params
    for key in reversedKeys
      if not params[key]
        _breadcrumb.pop()
      else
        changedParam = (parseInt(params[key]) != parseInt(_breadcrumb.val(key).id))
        if changedParam
          _breadcrumb.push(key, {type: key, id: parseInt(params[key])})

  _stateParamsToStateName = (params) ->
    sorted_types = Object.keys(params).sort().join('.')
    _states[sorted_types]

  _getBreadcrumbLabels = ->
    withoutLabel = (v for own k,v of getBreadcrumb() when not v.label and v.type isnt 'year')
    if withoutLabel.length
      drilldowns = (b.type for b in withoutLabel)
      openspending.aggregate(withoutLabel, drilldowns).then (response) ->
        for b in withoutLabel
          data = response.data.drilldown[0][b.type]
          dataStillRelevant = _breadcrumb.val(b.type)? and (parseInt(b.id) == parseInt(data.name))
          continue unless dataStillRelevant
          b.label = data.label
          _breadcrumb.push(b.type, b)
        updateState()

  _slugify = (element) ->
    slug = element.id
    slug += "-#{_slug(element.label)}" if element.label
    slug

  _slug = $filter('slug')

  _init = ->
    $rootScope.$on '$stateChangeSuccess', _updateBreadcrumb
    _initBreadcrumb()

  _init()

  href: href
  updateState: updateState
  back: back
  getBreadcrumb: getBreadcrumb

class OrderedHash
  # http://stackoverflow.com/questions/2798893/ordered-hash-in-javascript
  constructor: ->
    @keys = []
    @vals = {}

  push: (k, v) ->
    if not @vals[k]
      @keys.push k
    @vals[k] = v

  peek: ->
    lastKey = @keys[@keys.length - 1]
    @vals[lastKey]

  pop: ->
    key = @keys.pop()
    value = @vals[key]
    delete @vals[key]
    value

  all: ->
    (@vals[key] for key in @keys)

  val: (k) ->
    @vals[k]
