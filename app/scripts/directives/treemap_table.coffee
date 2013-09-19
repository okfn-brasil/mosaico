angular.module('fgvApp').directive 'treemapTable', ($filter, openspending, routing) ->
  columns = [
    { sTitle: '', bSortable: false, sClass: 'month' }
    { sTitle: 'Autorizado', bSortable: false, sClass: 'currency' }
    { sTitle: 'Pago', bSortable: false, sClass: 'currency' }
    { sTitle: 'RP Pago', bSortable: false, sClass: 'currency' }
    { sTitle: 'Pagamentos (Pago + RP Pago)', bSortable: false, sClass: 'currency' }
    { sTitle: 'Autorizado', bVisible: false } # Used just for sorting
    { sTitle: 'Entidade', bVisible: false } # Used just for sorting
  ]

  options =
    bPaginate: false
    aaSorting: [[ 5, 'desc' ], [ 6, 'asc' ]]
    sDom: 't'

  currencyFilter = $filter('currency')

  currency = (value) ->
    currencyFilter(value, '')

  restrict: 'E',
  scope:
    cuts: '='
    drilldown: '='
  template: '<my-data-table class="table graph-numbers" columns="columns" options="options" data="data"></my-data-table>'
  link: (scope, element, attributes) ->
    scope.columns = columns
    scope.options = options
    measures = attributes.measures.split('|')
    updateData = (cuts, drilldown) ->
      return unless cuts and drilldown
      openspending.aggregate(cuts, [drilldown], measures).then (response) ->
        data = []
        for d in response.data.drilldown
          url = routing.href({type: drilldown, id: d[drilldown].name, label: d[drilldown].label})
          label = d[drilldown].label
          label = "<a href='#{url}'>#{label}</a>" if url

          data.push [
            label
            currency(d.amount)
            currency(d.pago)
            currency(d.rppago)
            currency(d.pago + d.rppago)
            d.amount
            d[drilldown].label
          ]

        scope.data = data
    scope.$watch 'cuts + currentDrilldown', (-> updateData(scope.cuts, scope.drilldown)), true
