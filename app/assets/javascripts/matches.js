function updateLocationHash(hash){
  baseUrl = window.location.href.split('#')[0];
  window.location.replace(baseUrl + "#" + hash)
}

function initializeMatchForm(){
  $('#view-container [data-flatpickr]').flatpickr({
    altInput: true,
    altFormat: "M j, Y"
  });

  $('#view-container [data-inputmask]').inputmask()

  $('#view-container').find('select.dropdown:not(.custom), .ui.dropdown:not(.custom)').dropdown({
    placeholder: false
  });

  $('#match_opponent').dropdown({
    placeholder: false,
    allowAdditions: true,
    hideAdditions: false,
  });

  // By default, highest rating gets MOTM
  highest_rating = $('input.rating').map(function(){
    return this.value;
  }).get().sort().pop() || 0;

  $('#view-container table').on('input', '.rating', function(){
    if (parseFloat(this.value) > parseFloat(highest_rating)){
      highest_rating = this.value;
      setMOTM($('.ui.ribbon.pos', $(this).closest('tr')));
    }
  });

  // Clicking a ribbon label sets MOTM
  $('#view-container table').on('click', '.ui.ribbon.pos', function(){ setMOTM(this) });

  $('select[id$="squad_id"]').change(function(){ loadSquadPlayers(this) });

  $('#update-squad-btn').click(function(evt){ updateSquad(evt) });
}

function setMOTM(target){
  var playerId = $(target).closest('tr').find("select.player_id").val();
  if (playerId){
    $('#match_motm_id').val(playerId);
    $('.ui.ribbon.pos').removeClass('yellow');
    $(target).addClass('yellow');        
  }
}

// Squad auto populates players and positions
function loadSquadPlayers(target){
  console.log("in loadSquadPlayers")
  if ($(target).val()){
    $.get("/my_fifa/squads/"+$(target).val()+"/info", function(data){
      $.each(data.player_ids, function(i, player_id){
        var tr = $('#match_player_records_attributes_'+i+'_pos').closest('tr');
        $('select[id$="player_id"]', tr).val(player_id);

        // Update Position labels
        $('td:first-child input', tr)
          .attr('data-default', data.positions[i])
          .val(data.positions[i]);
        $('td:first-child .ribbon span', tr).text(data.positions[i]);
      });
    });
    $('#update-squad-btn').attr('disabled', false);
  } else
    $('#update-squad-btn').attr('disabled', true);      
}

function updateSquad(evt){
  evt.preventDefault();

  var squadId = $('select[id$="squad_id"]').val();
  var rows = $('#view-container table tbody tr:not([data-sub])');
  var squadParams = {};
  for(var i=0; i < 11; i++)
    squadParams['player_id_'+(i+1)] = $('.player_id', $(rows[i])).val();

  $.ajax({
    url: '/my_fifa/squads/'+squadId,
    type: 'PUT',
    beforeSend: function(xhr){ xhr.setRequestHeader('X-CSRF-Token', AUTH_TOKEN)},
    data: { 
      squad: squadParams,
      page:  'match',
    },
  });
}

// target is the table row from which to clone
function addRecord(target){
  // Generate new Record table row
  var record = $('<tr data-sub />');
  var id = moment().valueOf();
  if (target.is("[data-sub]"))
    record.append(
      target.html()
        .replace(/(\[sub_record_attributes\])/g, '$1[sub_record_attributes]')
        .replace(/(_sub_record_attributes)/g, '$1_sub_record_attributes')
    );
  else // Parent is not a Substitute
    record.append(
      target.html()
        .replace(/(\[player_records_attributes\])\[(\d+)\]/g, '$1[$2][sub_record_attributes]')
        .replace(/(_player_records_attributes)_(\d+)/g, '$1_$2_sub_record_attributes')
    );

  // Set Substitute behavior
  $('.pos .level.icon', record).last().css('visibility', 'hidden');
  $('.ui.ribbon.label', record).removeClass('yellow');

  // Remove Error classes
  $('.error', record).removeClass('error');

  $.each($('input,select', record), function(){
    $(this).val($(this).data('default'));
  });

  // Append new row to table
  target.after(record);
  target.find(".pos").append('<i class="level down red icon"></i>');
  $('.pos', record).append('<i class="level up green icon"></i>');

  return $(record);
}

function removeRecord(target){
  var parentTr = target.prev();

  target.transition({
    animation: 'slide down',
    onComplete: function(){
      $('.ribbon .level.icon', parentTr).last().remove();
      if (target.data('id'))
        $('input[id$="_destroy"]', target).val(1);
      else
        target.remove();
    }
  });
}

function changePosition(target, position){
  var trPos = target.find('.pos');
  $('span', trPos).text(position);
  trPos.prev()
    .attr('data-default', position)
    .val(position);
}

function replaceViewContainer(title, html, callback){
  callback = callback || function(){};
  $('#view-container').transition({
    animation: "scale",
    onComplete: function(){
      $("#new-match").toggleClass("disabled", window.location.hash == "#new");

      $('#view-container')
        .empty()
        .append(html)
        .prev().text(title);
      $('#view-container').transition({
        animation: "scale",
        onComplete: callback()
      });
    }
  })
}

function newMatchForm(){
  $.getJSON("/my_fifa/matches/new", function(data){
    $("table tbody tr.warning").removeClass("warning");
    updateLocationHash("new");
    replaceViewContainer("New Match", data, function(){
      initializeMatchForm();
    });
  });
}

function matchLogForm(target){
  $("#log-modal").modal({
    duration: 300,
    onShow: function(){
      var playerOptions = "<option></option>";
      $("table#players .player_id").each(function(){
        var playerId = $(this).val() || 0;
        if (playerId.length > 0)
          playerOptions += "<option value=\"" + playerId + "\">" + $(this).find("option:selected").text() + "</option>";
      });

      var positionOptions = "<option></option>";
      $("table#players .pos.ribbon.label > span").each(function(){
        positionOptions += "<option value=\"" + this.innerHTML + "\">" + this.innerHTML + "</option>";
      })

      $("#log-modal select.player_id").each(function(){ $(this).html(playerOptions) });
      $("#log-modal select#position").each(function(){  $(this).html(positionOptions) });

      // Populate form with existing attributes
      if (target){
        var event = target.find(".event").val();

        $("#log-modal #log_event_"+event).trigger("click");
        $("#log-modal input[name=\"log_event\"]").prop("disabled", true);

        $("#log-modal #player").val(target.find(".player1_id").val()).prop("disabled", true);
        $("#log-modal #log_minute").val(target.find(".minute").val());
        $("#log-modal").find("#sub_player, #assisted_by").val(target.find(".player2_id").val());
        $("#log-modal #position").val(target.find(".notes").val());
        if (event == "Booking")
          $("#log-modal #log_booking_"+target.find(".notes").val().replace(/\s/g, "_")).trigger("click");
      }
    },
    onApprove: function(){ // validate Match Event. If valid, update Match Log
      var event = $("#log-modal :radio:checked[name=\"log_event\"]").val() || "";
      var logData = {
        player1_id: $("#log-modal select.player_id").val(),
        event: event,
        minute: $("#log_minute").val(),
      };
      switch(event){
        case "Substitution":
          logData["player2_id"] = $("#log-modal #sub_player").val();
          logData["notes"] = $("#log-modal #position").val();
          break;
        case "Goal":
          logData["player2_id"] = $("#log-modal #assisted_by").val();
          break;
        case "Booking":
          logData["notes"] = $("#log-modal :radio:checked[name=\"log_booking\"]").val() || "";
          break;
      }

      $.ajax({
        url: "/my_fifa/matches/check_log",
        type: "POST",
        beforeSend: function(xhr){ xhr.setRequestHeader('X-CSRF-Token', AUTH_TOKEN)},
        data: { log: logData }
      }).then(function(data){
        if (data){

          if (target){ // Existing Event
            var playerId = target.find(".player2_id").val();

            target.find("td:first-child > span").text(data.minute+'"');
            target.find("td:nth-child(2)").html("<i class=\"" + data.icon + " icon\"></i>" + data.message)
            $.each(["player1_id", "player2_id", "minute", "notes", "event"], function(i, attr){
              target.find("."+attr).val(data[attr]);
            })

            if (event == "Substitution"){
              var subbed = $("table#players select.player_id option:selected[value=\""+playerId+"\"]").closest("tr");
              subbed.find("select.player_id").val(data.player2_id);
              changePosition(subbed, data.notes);
            }
          } else { // New Event
            var id = moment().valueOf();
            var row = $("<tr/>").append(
              $("#view-container table#logs tr.template").html()
                .replace(/match_logs_attributes_0/g, "match_logs_attributes_"+id)
                .replace(/match\[logs_attributes\]\[0\]/g, "match[logs_attributes]["+id+"]")
            );

            row.removeClass("template hidden transition");
            row.find("td:first-child > span").text(data.minute+'"');
            row.find("td:nth-child(2)").html("<i class=\"" + data.icon + " icon\"></i>" + data.message)
            $.each(["player1_id", "player2_id", "minute", "notes", "event"], function(i, attr){
              row.find("."+attr).val(data[attr]);
            })
            $("#view-container table#logs tbody").append(row);

            if (event == "Substitution"){
              var subbed = $("table#players select.player_id option:selected[value="+data.player1_id+"]").closest("tr");
              var subRow = addRecord(subbed);
              changePosition(subRow, data.notes);
              subRow.find(".player_id").val(data.player2_id);
            }
          }
          return true;
        } else
          alert("Invalid Match Event!")
          return false;
      });
    },
    onHide: function(){
      $('#log-modal .transition.visible').transition("slide down");
      $('#log-modal').find('input:not(:radio),select').prop("disabled", false).val("");
      $('#log-modal :radio').prop("disabled", false).prop("checked", false);
      $("#log-modal").modal("destroy");
    },
  }).modal('show');
}

/****************************
*  MATCH LOG FUNCTIONALITY  *
*****************************/

$(document).on("turbolinks:load", function(){
  $("#view-container").on("click", "#new-log", function(){ matchLogForm() });
  $("#view-container").on("click", "#edit-log", function(){ matchLogForm($(this).closest("tr")) });
  $("#view-container").on("click", "#remove-log", function(){
    var tr = $(this).closest("tr");
    var playerId = tr.find(".player2_id").val();

    // Remove Substitute Row in Players Table
    if (tr.find("input[id$=\"event\"]").val() == "Substitution"){
      subTr = $("table#players select.player_id option:selected[value="+playerId+"]").closest("tr");
      removeRecord(subTr);
    }

    if (tr.data("id")){
      tr.find("input[id$=\"_destroy\"]").val(1);
      tr.transition("slide down");
    } else
      tr.remove();  
  })

  // Selecting Player sets Position
  $("#log-modal select#player").change(function(){
    var tr = $("table#players select.player_id option:selected[value="+$(this).val()+"]").closest("tr");
    var pos = tr.find(".pos > span").text();
    $("#log-modal select#position").val(pos);
  });

  // Loads Event specific fields
  $("body").on("change", "#log-modal input[name=\"log_event\"]", function(){
    var value = this.value;
    if ($('#log-modal .transition.visible').length > 0)
      $('#log-modal .transition.visible').transition({
        animation: "slide down",
        onStart: function(){
          $('#log-modal .transition.visible :radio:checked').prop('checked', false);
          $('#log-modal .transition.visible').find('input:not(:radio),select').val("");
        },
        onComplete: function(){
          $('#log-modal [data-event="'+value+'"]').transition("slide down")
        }
      });
    else
      $('#log-modal [data-event="'+value+'"]').transition("slide down");
  });
});