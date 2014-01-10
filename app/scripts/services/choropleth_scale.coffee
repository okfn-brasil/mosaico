angular.module('fgvApp').factory 'choroplethScale', ($q, openspending) ->
  _scaleLevels = [
    { threshold: 0.20, className: 'level-0' }
    { threshold: 0.40, className: 'level-1' }
    { threshold: 0.60, className: 'level-2' }
    { threshold: 0.80, className: 'level-3' }
    { threshold: Infinity, className: 'level-4' }
  ]

  _getScaleLevels = (year) ->
    currentYear = new Date().getFullYear()
    scaleLevels = $.extend(true, [], _scaleLevels)
    if parseInt(year) == currentYear
      currentMonth = new Date().getMonth()
      percentualOfTheYearThatHasPassed = currentMonth / 12
      scaleLevels.map (level) ->
        level.threshold *= percentualOfTheYearThatHasPassed
    scaleLevels

  _classNameFor = (choropleth, levels) ->
    (node) ->
      percentualExecutado = choropleth[node.data.name]
      className = ''
      for level in levels
        if percentualExecutado < level.threshold
          className = level.className
          break
      className

  _scale = (choropleth, year) ->
    _levels = _getScaleLevels(year)

    levels: _levels
    classNameFor: _classNameFor(choropleth, _levels)

  get = (cuts, drilldown, measures) ->
    deferred = $q.defer()

    openspending.aggregate(cuts, [drilldown], measures).then (response) ->
      choropleth = {}
      for d in response.data.drilldown
        name = d[drilldown].name
        autorizado = d.amount
        executado = d.pago + d.rppago
        percentualExecutado = d.pago/d.amount
        choropleth[name] = percentualExecutado
      deferred.resolve(_scale(choropleth, cuts.year))

    deferred.promise

  get: get
