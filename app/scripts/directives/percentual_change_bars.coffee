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
    # IPCA deflator values from 2006 to 2012
    ipca_deflator = [6.15, 5.87, 8.33, 7.19, 8.23, 6.97, 5.35]

    cuts = breadcrumbToCuts(breadcrumb)
    delete cuts.year
    drilldown = [breadcrumb[breadcrumb.length - 1].type,
                 'year']
    bars = undefined
    openspending.aggregate(cuts, drilldown).then (response) ->
        #bars = ({ label: d.year, value: d.amount/totals[d.year] } for d in response.data.drilldown)
      console.log response.data.drilldown
      bars = ({ label: d.year, value: d.amount } for d in response.data.drilldown)
      bars.sort (a, b) ->
        parseInt(a.label) - parseInt(b.label)
        #reference = bars[0].value
        #for bar, i in bars
        #  if i == 0
        #    bar.delta = 0
        #  else
        #    delta = (bar.value / reference) - 1
        #    bar.delta = delta

        #scope.bars = addBarHeights(bars)
      scope.bars = bars

      barsData = [
        key: "Percentual"
        bar:
            true
        values: []
      ]

      for bar, i in bars
        barsData[0].values.push [parseInt(bar.label), bar.value]

      barsData.push 
        key: "IPCA"
        values: []

      defls = [1]
      for i in [(bars.length-2)..1]
          defls.push defls[bars.length - i - 2]*(1 - ipca_deflator[i]/100.0)

      defls = defls.reverse()

          #for bar, i in bars by -1
      for i in [0..defls.length-1]
        console.log bars[i].value,  bars[i].value/defls[i], defls[i]
        barsData[1].values.push [parseInt(bars[i].label), bars[i].value/defls[i]]

      barsData[1].values.push [parseInt(bars[bars.length-1].label), bars[bars.length-1].value]
      scope.y2max = Math.max (b[1] for b in barsData[1].values)...

      console.log "L", barsData

      scope.barsData = barsData

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
