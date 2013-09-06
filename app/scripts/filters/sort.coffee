angular.module('fgvApp').filter 'sort', ->
  ascendingSort = (a,b) -> a - b
  descendingSort = (a,b) -> b - a

  (values, order) ->
    return unless values
    # We don't want to change the received value variable
    valuesCopy = values.slice()
    if order == 'desc'
      valuesCopy.sort(descendingSort)
    else
      valuesCopy.sort(ascendingSort)

