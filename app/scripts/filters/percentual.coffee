angular.module('fgvApp').filter 'percentual', ->
  round = (value) ->
    absValue = Math.abs(value)
    decimalCases = if absValue > 100
                     0
                   else if absValue > 10
                     1
                   else
                     2

    value.toFixed(decimalCases).replace('.', ',')

  (value) ->
    round(value*100 || 0) + '%'
