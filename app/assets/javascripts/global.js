// Contains universal JS code for the entire system

var vars = {};

$(function(){
  $('.flatpickr').flatpickr({ altInput: true });

  $('.data-table').each(function(){
    // Click behavior if table has links to other pages
    if ((_dTLink = $(this).data('link'))){
      $(this).on('click', 'tbody tr', function(evt){
        if ((_dTRowId = $(this).data('id')) && !$(evt.target).closest('td').is('[no-link]')){
          if (evt.ctrlKey)
            window.open(_dTLink + _dTRowId);
          else
            window.location = _dTLink + _dTRowId;
        }
      })
    }

    // Set columns that can't be sorted or filtered
    var _unsortable = [];
    var _unfilterable = [];
    $('thead th', $(this)).each(function(i, th){
      if ($(th).is('[no-sort]'))
        _unsortable.push(i);
      if ($(th).is('[no-filter]'))
        _unfilterable.push(i);
    })

    var _dataTable = $(this).DataTable({
      columnDefs: [
        { targets: _unsortable, sortable: false },
        { targets: _unfilterable, searchable: false },
      ]
    });

    // Dynamically set variable name for page-specific JS
    if ($(this).data('var'))
      vars[$(this).data('var')] = _dataTable;
  });

  $('.full-score').inputmask({
    mask: "9{1,2}[ \(9{1,2}\)]",
    greedy: false,
    skipOptionalPartCharacter: ' '
  })
})