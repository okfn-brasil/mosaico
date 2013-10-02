angular.module('fgvApp').directive 'treemapTable', ($filter, openspending, routing) ->
  columns = [
    { sTitle: '', bSortable: false, sClass: 'cut' }
    { sTitle: 'Autorizado', bSortable: true, sClass: 'currency', sType: 'currency' }
    { sTitle: 'Pago', bSortable: true, sClass: 'currency', sType: 'currency' }
    { sTitle: 'RP Pago', bSortable: true, sClass: 'currency', sType: 'currency' }
    { sTitle: 'Pagamentos (Pago + RP Pago)', bSortable: true, sClass: 'currency', sType: 'currency' }
  ]

  options =
    bPaginate: false
    aaSorting: [[ 2, 'desc' ], [ 3, 'desc' ], [ 4, 'asc']]
    sDom: 'ft'

  currencyFilter = $filter('currency')

  currency = (value) ->
    currencyFilter(value, '')

  breadcrumbToCuts = (breadcrumb) ->
    breadcrumb.reduce(((cuts, element) ->
      cuts[element.type] = element.id
      cuts
    ), {})

  currencyToFloat = (value) ->
    parseFloat(value.replace(/\./g, '').replace(',', '.'))

  $.fn.dataTableExt.oSort['currency-asc'] = (x, y) ->
    currencyToFloat(x) - currencyToFloat(y)

  $.fn.dataTableExt.oSort['currency-desc'] = (x, y) ->
    currencyToFloat(y) - currencyToFloat(x)

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

          data.push [
            label
            currency(d.amount)
            currency(d.pago)
            currency(d.rppago)
            currency(d.pago + d.rppago)
          ]

        scope.data = data
    scope.$watch routing.getBreadcrumb, ((breadcrumb) -> updateData(breadcrumb, scope.drilldown)), true
