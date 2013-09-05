angular.module('fgvApp').factory 'routing', ->
  api = {}

  api.loadParamsInOrder = (state) ->
    # We convert the state.params to an array in the same order as the states
    # urls were defined (i.e. if the state is treemap.year.funcao, year will
    # appear before funcao)
    taxonomies = state.current.name.split('.')
    params = state.params
    ({type: key, id: params[key]} for key in taxonomies when params[key]) || []

  api.updateState = (baseStateName, params, state) ->
    states = (s.type for s in params)
    stateNames = [baseStateName].concat(states)
    stateName = stateNames.join('.')
    stateParams = {}
    for param in params
      stateParams[param.type] = param.id
    state.go(stateName, stateParams)

  api
