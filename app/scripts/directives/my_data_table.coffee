angular.module('fgvApp').directive 'myDataTable', ($compile) ->
  buildTable = (element, columns, options) ->
    default_options =
      aoColumns: columns
      bSort: true
      sDom: 'fpti'
      sPaginationType: 'full_numbers'
      oLanguage:
        sSearch: '<i class="entypo">&#128269;</i>'
        sZeroRecords: 'Nenhum resultado encontrado.'
        sInfo: 'Mostrando de _START_ até _END_ de _TOTAL_ registros'
        sInfoFiltered: '(_MAX_ registros no total)'
        oPaginate:
          sFirst: 'Primeiro'
          sPrevious: 'Anterior'
          sNext: 'Próxima'
          sLast: 'Última'

    element.dataTable $.extend(default_options, options)

  restrict: 'E',
  template: '<table class="table table-bordered table-condensed"></table>',
  scope:
    columns: '='
    options: '='
    data: '='
  link: (scope, element, attributes) ->
    table = element.children('table')
    dataTable = undefined
    scope.$watch 'columns + options', ->
      [columns, options] = [scope.columns, scope.options]
      options.fnCreatedRow = (nRow) ->
        $compile(nRow)(scope)
      if columns
        dataTable = buildTable(table, columns, options)
    scope.$watch 'data', (data) ->
      if dataTable && data
        dataTable.fnClearTable()
        dataTable.fnAddData(scope.$eval(attributes.data))
