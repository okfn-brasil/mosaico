angular.module('fgvApp').directive 'treemapTable', ($filter, openspending, routing) ->
  columns = [
    { sTitle: '', bSortable: false }
    { sTitle: '', bSortable: false, sClass: 'cut' }
    { sTitle: '<i class="entypo not-sorted">&#59215;</i><i class="entypo desc">&#9662;</i><i class="entypo asc">&#9652;</i>&nbsp;Autorizado', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<i class="entypo not-sorted">&#59215;</i><i class="entypo desc">&#9662;</i><i class="entypo asc">&#9652;</i>&nbsp;Pago', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<i class="entypo not-sorted">&#59215;</i><i class="entypo desc">&#9662;</i><i class="entypo asc">&#9652;</i>&nbsp;RP Pago', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<i class="entypo not-sorted">&#59215;</i><i class="entypo desc">&#9662;</i><i class="entypo asc">&#9652;</i>&nbsp;Pagamentos (Pago + RP Pago)', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<i class="entypo not-sorted">&#59215;</i><i class="entypo desc">&#9662;</i><i class="entypo asc">&#9652;</i>&nbsp;Executado', bSortable: true, sClass: 'percentual', sType: 'formattedNumber' }
  ]

  options =
    bPaginate: false
    aaSorting: [[ 2, 'desc' ], [ 3, 'desc' ], [ 4, 'desc']]
    sDom: 'ft'
    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      # Line Numbers
      nRow.children[0].innerHTML = iDisplayIndex + 1

      # Bars for the "Executado" column
      executadoCol = nRow.children[nRow.children.length - 1]
      formattedPercentual = executadoCol.innerHTML
      unformattedPercentual = formattedPercentual.replace(',', '.')
      executadoCol.innerHTML = "<div class='meter-horizontal-wrapper'><div class='meter-horizontal scale-positive' style='width: #{unformattedPercentual};'></div></div><span class='meter-horizontal-label'>#{formattedPercentual}</span>"

      nRow

  currencyFilter = $filter('currency')

  currency = (value) ->
    currencyFilter(value, '')

  percentual = $filter('percentual')

  breadcrumbToCuts = (breadcrumb) ->
    breadcrumb.reduce(((cuts, element) ->
      cuts[element.type] = element.id
      cuts
    ), {})

  formattedNumberToFloat = (value) ->
    parseFloat(value.replace(/\./g, '').replace(',', '.'))

  $.fn.dataTableExt.oSort['formattedNumber-asc'] = (x, y) ->
    formattedNumberToFloat(x) - formattedNumberToFloat(y)

  $.fn.dataTableExt.oSort['formattedNumber-desc'] = (x, y) ->
    formattedNumberToFloat(y) - formattedNumberToFloat(x)

  restrict: 'E',
  scope:
    drilldown: '='
  template: '<my-data-table class="table graph-numbers" columns="columns" options="options" data="data"></my-data-table>'
  link: (scope, element, attributes) ->
    elementsCache = {}
    scope.columns = columns
    scope.options = options
    scope.click = (id) ->
      routing.updateState(elementsCache[id])
    measures = attributes.measures.split('|')
    updateData = (breadcrumb, drilldown) ->
      return unless breadcrumb and drilldown
      cuts = breadcrumbToCuts(breadcrumb)
      openspending.aggregate(cuts, [drilldown], measures).then (response) ->
        data = []
        for d in response.data.drilldown
          element = {type: drilldown, id: d[drilldown].name, label: d[drilldown].label}
          elementsCache[element.id] = element
          url = routing.href(element)
          label = element.label
          label = "<a ng-click=\"$parent.click(#{element.id})\" href=\"#{url}\">#{label}</a>" if url
          pagamentos = d.pago + d.rppago
          percentualExecutado = pagamentos/d.amount

          data.push [
            ''
            label
            currency(d.amount)
            currency(d.pago)
            currency(d.rppago)
            currency(pagamentos)
            percentual(percentualExecutado)
          ]

        scope.data = data
    scope.$watch routing.getBreadcrumb, ((breadcrumb) -> updateData(breadcrumb, scope.drilldown)), true
