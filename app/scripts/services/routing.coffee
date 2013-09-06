angular.module('fgvApp').factory 'routing', ($filter) ->
  loadParamsInOrder = (state) ->
    # We convert the state.params to an array in the same order as the states
    # urls were defined (i.e. if the state is treemap.year.funcao, year will
    # appear before funcao)
    taxonomies = state.current.name.split('.')
    params = state.params
    ({type: key, id: params[key]} for key in taxonomies when params[key]) || []

  updateState = (baseStateName, params, state) ->
    states = (s.type for s in params)
    stateNames = [baseStateName].concat(states)
    stateName = stateNames.join('.')
    stateParams = {}
    for param in params
      slug = param.id
      slug += "-#{_slug(param.label)}" if param.label
      stateParams[param.type] = slug
    state.go(stateName, stateParams)

  _slug = $filter('slug')

  loadParamsInOrder: loadParamsInOrder
  updateState: updateState
