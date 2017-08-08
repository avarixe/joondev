// Contains universal JS code for the entire system

var vars = {};
var flatPickers = [];

$(function(){

  $('.datepicker').each(function(){
    initFlatpickr(this);
  })

  // Click behavior if table has links to other pages
  $('html').on('click', 'table tbody tr', function(evt){
    if ((_dTLink = $(this).closest('table').data('link')) &&
        (_dTRowId = $(this).data('id')) &&
        !$(evt.target).closest('td').is('[no-link]')){
      if (evt.ctrlKey)
        window.open(_dTLink + _dTRowId);
      else
        window.location = _dTLink + _dTRowId;
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

    var _dataTable = $(this).DataTable({
      columnDefs: [
        { targets: _unsortable, sortable: false },
        { targets: _unfilterable, searchable: false },
      ],
    });

    // Dynamically set variable name for page-specific JS
    if ($(this).data('var'))
      vars[$(this).data('var')] = _dataTable;
  });

  // Collapsible panels collapse from clicking the panel heading
  $(document).on('click', '.panel-heading', function(){
    $('.panel-collapse', $(this).closest('.panel')).toggle('collapse');
  });

  // All Forms have checks for Dirty Input
  if ($('form').length > 0){
    $('form').dirtyForms();
  }
})

function initFlatpickr(target){
  fp = $(target).flatpickr({
    altInput: true,
    static: true,
    onChange: function(selectedDates, dateStr, instance){
      $(instance.input).data('dfOrig') != dateStr ?
        $(instance.altInput).addClass('dirty') :
        $(instance.altInput).removeClass('dirty');
    }
  });
  flatPickers.push(fp);
  return fp;
}

function initFullScore(target){
  var _input = $(target);
  var _dfOrig = $(target).val();

  _input.inputmask({
    mask: "9{1,2}[ \(9{1,2}\)]",
    greedy: false,
    skipOptionalPartCharacter: ' ',
    onBeforeWrite: function(evt, buffer, caretPos, opts){
      (_dfOrig != buffer.join("")) ?
        _input.addClass('dirty') :
        _input.removeClass('dirty');

      _input.trigger('click');
      return true;        
    }
  });
}