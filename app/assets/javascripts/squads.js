function initSquadForm(){
  $("#view-container select").dropdown({
    placeholder: false
  });

  // Dropdown menu support for grouped selects
  $('.ui.dropdown').has('optgroup').each(function(){
    var $menu = $('<div/>').addClass('menu');
    $(this).find('select > option').each(function(){
      $menu.append('<div class="item" data-value="">' + this.innerHTML + '</div>');
    })
    $(this).find('optgroup').each(function(){
      $menu.append('<div class="ui horizontal divider">' + this.label + '</div>');
      $(this).children().each(function(){
        $menu.append('<div class="item" data-value="' + this.value + '">' + this.innerHTML + '</div>');        
      })
    })
    $(this).find('.menu').html($menu.html());
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