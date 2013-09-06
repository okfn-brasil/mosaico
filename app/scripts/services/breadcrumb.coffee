angular.module('fgvApp').factory 'breadcrumb', (openspending) ->
  _cuts = []

  add = (cuts) ->
    if not $.isArray(cuts)
      cuts = [cuts]
    cutsWithoutLabel = (cut for cut in cuts when not cut.label)
    if cutsWithoutLabel.length
      drilldowns = (cut.type for cut in cutsWithoutLabel)
      openspending.aggregate(cutsWithoutLabel, drilldowns).then (response) ->
        for cut in cutsWithoutLabel
          data = response.data.drilldown[0][cut.type]
          label = data.label || data
          cut.label = label
    _cuts = _cuts.concat(cuts)

  get = -> _cuts

  pop = ->
    _cuts.pop()

  peek = ->
    _cuts[_cuts.length - 1]

  add: add
  get: get
  pop: pop
  peek: peek
