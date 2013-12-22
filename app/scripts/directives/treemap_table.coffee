angular.module('fgvApp').directive 'treemapTable', ($filter, openspending, routing) ->

  autorizadoTitle = '<span class="headerTooltip" title="Valor autorizado no orçamento do ano"><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Autorizado</span>'
  columns = [
    { sTitle: '', bSortable: false }
    { sTitle: '', bSortable: false, sClass: 'cut' }
    { sTitle: '<span class="headerTooltip" title="Valor autorizado no orçamento do ano"><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Autorizado</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp; Porcentagem do<br>Autorizado</span>', bSortable: true, sClass: 'percentual', sType: 'percentualBars' }
    #    { sTitle: '<span class="headerTooltip" title="Valor que foi efetivamente pago do orçamento autorizado do ano"><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Pago</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span class="headerTooltip" title="São compromissos assumidos no ano anterior, mas não foram executados naquele ano tendo sido direcionados para o ano seguinte. São valores não previstos no orçamento autorizado, constituindo uma verba extra-orçamental para aquele ano."><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Restos a Pagar<br>Inscritos (RP)</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span class="headerTooltip"><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Execução<br> do RP</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span class="headerTooltip" title="Refere-se a todo valor que sai da caixa do governo, isto é, Valor Pago mais os Restos a Pagar."><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Desembolso<br>Financeiro</span>', bSortable: true, sClass: 'currency', sType: 'formattedNumber' }
    { sTitle: '<span class="headerTooltip" title="É uma porcentagem de execução do valor autorizado pelo governo para o ano."><i class="icon-sort not-sorted"></i><i class="icon-sort-down desc"></i><i class="icon-sort-up asc"></i>&nbsp;Execução Total</span>', bSortable: true, sClass: 'percentual', sType: 'percentualBars' }
  ]

  options =
    bPaginate: false
    aaSorting: [[ 2, 'desc' ], [ 3, 'desc' ], [ 4, 'desc']]
    sDom: 'ft'
    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      nRow.children[0].innerHTML = iDisplayIndex + 1
      nRow

  parsePercent = (x) ->
    return parseFloat((x.replace /%/, "").replace /,/, ".")

  comparePercent = (ord, x,y) ->
    x = parsePercent(x)
    y = parsePercent(y)

    switch ord
      when 'A' then x - y
      when 'D' then y - x

  $.fn.dataTableExt.oSort['percentualBars-asc'] = (x, y) ->
    comparePercent('A', x, y)

  $.fn.dataTableExt.oSort['percentualBars-desc'] = (x, y) ->
    comparePercent('D', x, y)

  $.fn.dataTableExt.oSort['formattedNumber-asc'] = (x, y) ->
    formattedNumberToFloat(x) - formattedNumberToFloat(y)

  $.fn.dataTableExt.oSort['formattedNumber-desc'] = (x, y) ->
    formattedNumberToFloat(y) - formattedNumberToFloat(x)

  sortPercentualBarsBy = (x, y, order) ->
    xElement = $(x)[1]
    yElement = $(y)[1]
    xValue = (xElement and xElement.innerHTML) or -Infinity
    yValue = (yElement and yElement.innerHTML) or -Infinity

    $.fn.dataTableExt.oSort["percentualBars-#{order}"](xValue, yValue)

  currencyFilter = $filter('currency')

  currency = (value) ->
    currencyFilter(value/Math.pow(10, 6), '')

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
      lastLevel = breadcrumb[breadcrumb.length - 1].label
      if not lastLevel?
          lastLevel = "Uniao"
      scope.columns[2].sTitle = autorizadoTitle.replace /LL/, lastLevel
      return unless breadcrumb and drilldown
      cuts = breadcrumbToCuts(breadcrumb)
      openspending.aggregate(cuts, [drilldown], measures).then (response) ->
        data = []
        total = 0
        total_rppago = 0
        for d in response.data.drilldown
          total = total + d.amount
          total_rppago = total_rppago + d.rppago
        for d in response.data.drilldown
          element = {type: drilldown, id: d[drilldown].name, label: d[drilldown].label}
          elementsCache[element.id] = element
          url = routing.href(element)
          label = element.label
          label = "<a ng-click=\"$parent.click(#{element.id})\" href=\"#{url}\">#{label}</a>" if url
          pagamentos = d.pago + d.rppago
          percentualExecutadoLabel = if d.amount != 0
            percentualExecutado = pagamentos/(d.amount + d.rppago)
            percentual(percentualExecutado)
          else
            ''

          data.push [
            ''
            label
            currency(d.amount)
            percentual(d.amount/total)
              #        currency(d.pago)
            currency(d.rppago)
            percentual(d.rppago/total_rppago)
            currency(pagamentos)
            percentualExecutadoLabel
          ]

          $('.headerTooltip').tipsy({clsStyle: 'yellow', gravity: 's', opacity: '1'})

        scope.data = data
    scope.$watch routing.getBreadcrumb, ((breadcrumb) -> updateData(breadcrumb, scope.drilldown)), true
