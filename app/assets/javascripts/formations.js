function organizePositions(){
  var layout = $('#formation_layout').val().split('-').map(function(n){
    return parseInt(n)
  });

  var rows = [[]];
  var nRow = 0;     // current row index
  var posInRow = 0; // counter of pos in currow row
  
  for (var pos=2; pos <= 11; pos++){
    // If reached threshold of row, create next row
    if (rows[nRow].length == layout[nRow]){      
      nRow++;
      rows.push([]);
    }
    rows[nRow].push(pos);
  }

  // Clear the grid of the previous layout
  $('.field.pos[data-no != 1]').appendTo('#positions-container');
  $('#positions-grid > .row:not(:last-child)').remove();

  // Repopular the grid with row data
  for (var i=0; i < rows.length; i++){
    rowClass = (rows[i].length % 2 == 0 ? 'four' : 'five') + " columns centered row"
    // Collect rows in container
    rowElem = $('<div class="'+rowClass+'"></div>')
    for (var j=0; j < rows[i].length; j++)
      $('#positions-container .field[data-no='+rows[i][j]+']').appendTo(rowElem);
    // Add row to stackable grid
    $('#positions-grid').prepend(rowElem);
  }
  
  $('#positions-grid').transition({
    animation: 'pulse',
    queue: false
  });
}

function initFormationForm(){
  $("#view-container select").dropdown();

  organizePositions();
  $('#view-container #formation_layout').change(function(){
    organizePositions();
  })
}

function newFormationForm(){
  $.getJSON("/my_fifa/formations/new", function(data){
    $("table tbody tr.warning").removeClass("warning");
    updateLocationHash("new");
    replaceViewContainer("New Formation", data, function(){
      initFormationForm()
    });
  })
}

function viewFormation(id){
  if (currentView != id) {
    $("table#formations tbody tr.warning").removeClass("warning");
    $("table#formations tr[data-id=\""+id+"\"]").addClass("warning");
    $.getJSON("/my_fifa/formations/"+id, function(data){
      currentView = id;
      updateLocationHash(id);
      replaceViewContainer("Formation View", data, function(){
        initFormationForm()
      });
    });
  }
}

$(function(){
  /*********************************
  *  VIEW CONTAINER FUNCTIONALITY  *
  *********************************/
  switch(window.location.hash){
  case '#new':
    newFormationForm();
  case '':
    break;
  default:
    currentView = parseInt(window.location.hash.replace(/#/g, ''));
    $.getJSON('/my_fifa/formations/' + currentView, function(data){
      replaceViewContainer('Formation View', data, function(){
        initFormationForm()
      })
    });
  }

  $('#new-form').click(function(){ newFormationForm() });

  $(".pusher").on("click", "table#formations tbody tr", function(evt){
    id = $(this).data("id");
    if (window.location.hash != "#"+id)
      if (evt.ctrlKey || evt.metaKey)
        window.open("/my_fifa/formations#"+id)
      else {
        if (window.location.hash == "#new" && !confirm("View Formation #"+id+"? Unsaved Formation will be lost."))
          return;
        viewFormation(id);
      }
  });
})