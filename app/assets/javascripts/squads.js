function organizePositions(){
  $.getJSON("/my_fifa/formations/"+$("#squad_formation_id").val()+"/info", function(data){
    var layout = data.layout.split("-");
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
      for (var j=0; j < rows[i].length; j++){
        var positionField = $('#positions-container .field[data-no='+rows[i][j]+']')
        positionField.attr("data-tooltip", data["pos_"+rows[i][j]]);
        positionField.appendTo(rowElem);
      }
      // Add row to stackable grid
      $('#positions-grid').prepend(rowElem);
    }
    
    $('#positions-grid').transition({
      animation: 'pulse',
      queue: false
    });

  });
}

function initSquadForm(){
  $("#view-container #squad_formation_id").dropdown({
    placeholder: false
  });

  $("#view-container .pos.field > select").select2({
    width: "100%",
    placeholder: "Player"
  });

  $("#view-container #squad_formation_id").change(function(){
    organizePositions();
  });
}

function newSquadForm(){
  $.getJSON("/my_fifa/squads/new", function(data){
    $("table tbody tr.warning").removeClass("warning");
    updateLocationHash("new");
    replaceViewContainer("New Squad", data, function(){
      initSquadForm()
    });
  })
}

function viewSquad(id){
  if (currentView != id) {
    $("table#squads tbody tr.warning").removeClass("warning");
    $("table#squads tr[data-id=\""+id+"\"]").addClass("warning");
    $.getJSON("/my_fifa/squads/"+id, function(data){
      currentView = id;
      updateLocationHash(id);
      replaceViewContainer("Squad View", data, function(){
        initSquadForm()
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
    newSquadForm();
  case '':
    break;
  default:
    currentView = parseInt(window.location.hash.replace(/#/g, ''));
    $.getJSON('/my_fifa/squads/' + currentView, function(data){
      replaceViewContainer('Squad View', data, function(){
        initSquadForm()
      })
    });
  }

  $('#new-form').click(function(){ newSquadForm() });

  $(".pusher").on("click", "table#squads tbody tr", function(evt){
    id = $(this).data("id");
    if (window.location.hash != "#"+id)
      if (evt.ctrlKey || evt.metaKey)
        window.open("/my_fifa/squads#"+id)
      else {
        if (window.location.hash == "#new" && !confirm("View Squad #"+id+"? Unsaved Squad will be lost."))
          return;
        viewSquad(id);
      }
  });
})