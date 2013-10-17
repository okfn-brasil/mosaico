angular.module('fgvApp').directive 'treemapTable', ($filter, openspending, routing) ->
  columns = [
    { sTitle: '', bSortable: false }
    { sTitle: '', bSortable: false, sClass: 'cut' }
    { sTitle: '<span><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Autorizado</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Pago</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Restos a pagar<br>pagos</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span title="Soma de valores pagos e restos a pagar pagos"><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Desembolso<br>Financeiro</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Executado</span>', bSortable: true, sClass: 'percentual', sType: 'percentualBars' }
  ]

  options =
    bPaginate: false
    aaSorting: [[ 2, 'desc' ], [ 3, 'desc' ], [ 4, 'desc']]
    sDom: 'ft'
    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      nRow.children[0].innerHTML = iDisplayIndex + 1
      nRow

  $.fn.dataTableExt.oSort['percentualBars-asc'] = (x, y) ->
    sortPercentualBarsBy(x, y, 'asc')

  $.fn.dataTableExt.oSort['percentualBars-desc'] = (x, y) ->
    sortPercentualBarsBy(x, y, 'desc')

  $.fn.dataTableExt.oSort['formattedNumber-asc'] = (x, y) ->
    formattedNumberToFloat(x) - formattedNumberToFloat(y)

  $.fn.dataTableExt.oSort['formattedNumber-desc'] = (x, y) ->
    formattedNumberToFloat(y) - formattedNumberToFloat(x)

  sortPercentualBarsBy = (x, y, order) ->
    xElement = $(x)[1]
    yElement = $(y)[1]
    xValue = (xElement and xElement.innerHTML) or -Infinity
    yValue = (yElement and yElement.innerHTML) or -Infinity

    $.fn.dataTableExt.oSort["formattedNumber-#{order}"](xValue, yValue)

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
    return value unless value.replace
    parseFloat(value.replace(/\./g, '').replace(',', '.'))

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
          percentualExecutadoLabel = if d.amount != 0
            percentualExecutado = pagamentos/d.amount
            percentual(percentualExecutado)
          else
            ''

          data.push [
            ''
            label
            currency(d.amount)
            currency(d.pago)
            currency(d.rppago)
            currency(pagamentos)
            percentualExecutadoLabel
          ]

        scope.data = data
    scope.$watch routing.getBreadcrumb, ((breadcrumb) -> updateData(breadcrumb, scope.drilldown)), true
