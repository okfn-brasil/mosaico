angular.module('fgvApp').directive 'percentualChangeBars', ($q, openspending, routing) ->
  breadcrumbToCuts = (breadcrumb) ->
    breadcrumb.reduce(((cuts, element) ->
      cuts[element.type] = element.id
      cuts
    ), {})

  addBarHeights = (bars) ->
    maxTargetRange = 100
    maxDelta = 0
    for own _, bar of bars
      delta = Math.abs(bar.delta)
      maxDelta = delta if delta > maxDelta
    convertRange = (value) ->
      Math.abs((value * maxTargetRange) / maxDelta)
    for own _, bar of bars
      bar.height = convertRange(bar.delta)
    bars

  updateBars = (scope, breadcrumb, totals) ->
    cuts = breadcrumbToCuts(breadcrumb)
    delete cuts.year
    drilldown = [breadcrumb[breadcrumb.length - 1].type,
                 'year']
    bars = undefined
    openspending.aggregate(cuts, drilldown).then (response) ->
      bars = ({ label: d.year, value: d.amount/totals[d.year] } for d in response.data.drilldown)
      bars.sort (a, b) ->
        parseInt(a.label) - parseInt(b.label)
      reference = bars[0].value
      for bar, i in bars
        if i == 0
          bar.delta = 0
        else
          delta = (bar.value / reference) - 1
          bar.delta = delta

      scope.bars = addBarHeights(bars)

  restrict: 'E'
  templateUrl: '/views/partials/percentual_change_bars.html'
  scope:
    year: '='
  link: (scope, element, attributes) ->
    openspending.aggregate(undefined, ['year']).then (response) ->
      totals = {}
      for drilldown in response.data.drilldown
        totals[drilldown.year] = drilldown.amount
      scope.totals = totals

    callback = ->
      breadcrumb = routing.getBreadcrumb()
      if breadcrumb and scope.totals
        updateBars(scope, breadcrumb, scope.totals)

    scope.$watch routing.getBreadcrumb, callback, true
    scope.$watch 'totals', callback
