// Contains universal JS code for the entire system

$(function(){
  // Click behavior if table has links to other pages
  $('html').on('click', 'table tbody tr', function(evt){
    if ((_link = $(this).closest('table').data('link')) &&
        (_rowId = $(this).data('id')) &&
        !$(evt.target).closest('td').is('[no-link]')){
      if (evt.ctrlKey)
        window.open(_link + _rowId);
      else
        window.location = _link + _rowId;
    }
  });

  $('.data-table').each(function(){
    // Set columns that can't be sorted or filtered
    var _unsortable = [];
    var _unfilterable = [];
    $('thead th', $(this)).each(function(i, th){
      if ($(th).is('[no-sort]'))
        _unsortable.push(i);
      if ($(th).is('[no-filter]'))
        _unfilterable.push(i);
    })

    $(this).DataTable({
      columnDefs: [
        { targets: _unsortable, sortable: false },
        { targets: _unfilterable, searchable: false },
      ],
    });
  });

  // Collapsible panels collapse from clicking the panel heading
  // $(document).on('click', '.panel-heading', function(){
  //   $('.panel-collapse', $(this).closest('.panel')).toggle('collapse');
  // });
})

function initFlatpickr(target){
  fp = $(target).flatpickr({
    altInput: true,
    static: true,
  });
  return fp;
}

function saveOrigVal(scope){
  $('input', scope).each(function(){
    $(this).data(
      'origVal', 
      $(this).attr('type') == 'checkbox' ?
        $(this).prop('checked') :
        $(this).val()
    );
  })
}

function triggerTrField(target){
  var tr = $(target).closest('tr');

  var value = $(target).attr('type') == 'checkbox' ?
    $(target).prop('checked') :
    $(target).val();

  value != $(target).data('origVal') ?
    $(target).addClass('dirty') :
    $(target).removeClass('dirty');

  $('.update-btn', tr).prop('disabled', $('.dirty', tr).length == 0);      
}