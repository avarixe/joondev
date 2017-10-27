function initializeMatchForm(){
  updatePositionOptions();

  $('#view-container [data-flatpickr]').flatpickr({
    altInput: true,
    altFormat: "M j, Y"
  });

  $('#view-container').find('select.dropdown:not(.custom), .ui.dropdown:not(.custom)').dropdown({
    placeholder: false
  });

  $('#match_opponent').dropdown({
    placeholder: false,
    allowAdditions: true,
    hideAdditions: false,
  });

  // Dropdown menu support for grouped selects
  $('.ui.dropdown').has('optgroup').each(function(){
    var menu = $('<div/>').addClass('menu');
    $(this).find('select > option').each(function(){
      menu.append('<div class="item" data-value="">' + this.innerHTML + '</div>');
    });
    $(this).find('optgroup').each(function(){
      menu.append('<div class="ui horizontal divider">' + this.label + '</div>');
      $(this).children().each(function(){
        menu.append('<div class="item" data-value="' + this.value + '">' + this.innerHTML + '</div>')
      });
    });
    $(this).find('.menu').html(menu.html());
  });

  $('.pusher').on('click', '[data-clickfield] a[data-clickaction]', function(){ toggleClickForm(this); });
  $('.pusher').on('click', 'a[data-action]',               function(){ $(this).removeClass('active selected'); });
  $('.pusher').on('click', 'a[data-action="add sub"]',     function(){ addRecord(this); });
  $('.pusher').on('click', 'a[data-action="remove"]',      function(){ removeRecord(this); });
  $('.pusher').on('click', 'a[data-action="yellow card"]', function(){ addYellowCard(this); });
  $('.pusher').on('click', 'a[data-action="red card"]',    function(){ addRedCard(this); });
  $('.pusher').on('click', 'a[data-action="clear card"]',  function(){ clearBooking(this); });
  $('.pusher').on('input', '#pos_change',                  function(){ changePosition(this); });

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

function updatePositionOptions(){
  positions = $('#view-container table tr:not([data-sub]) .pos > span').map(function(){
    return $(this).text();
  }).toArray();
}

function changePosition(target){
  if (positions.indexOf(target.value) >= 0){
    var trPos = $('.pos', $(target).closest('tr'));
    $('span', trPos).text(target.value);
    trPos.prev()
      .attr('data-default', target.value)
      .val(target.value);
    $(target).val('');
  }
}

// Squad auto populates players and positions
function loadSquadPlayers(target){
  if ($(target).val()){
    $.get("/my_fifa/squads/"+$(target).val()+"/info", function(data){
      $.each(data.player_ids, function(i, player_id){
        var tr = $('#match_player_records_attributes_'+i+'_pos').closest('tr');
        $('select[id$="player_id"]', tr).dropdown('set selected', player_id);

        // Update Position labels
        updatePositionOptions();
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
    squadParams['player_id_'+(i+1)] = $('.player_id', $(rows[i])).dropdown('get value');

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

function toggleClickForm(target){
  var inputField = $(target).closest('[data-clickfield]').find('input');
  var currentValue = parseInt(inputField.val());

  var newValue = null;
  switch($(target).data('clickaction')){
    case 'add':
      newValue = isNaN(currentValue) ? 1 : currentValue+1;
      break;
    case 'sub':
      if (currentValue > 1)
        newValue = currentValue - 1;
  }

  inputField.val(newValue);
  $('.or', $(target).closest('[data-clickfield]')).attr('data-text', newValue || 0);
}

function addRecord(target){
  // Generate new Record table row
  var record = $('<tr data-sub />');
  var id = moment().valueOf();
  if ($('input[id$="pos"]', $(target).closest('tr')).attr('id').indexOf('sub_record') > 0)
    record.append($(target).closest('tr').html()
      .replace(/(\[sub_record_attributes\])/g, '$1[sub_record_attributes]')
      .replace(/(_sub_record_attributes)/g, '$1_sub_record_attributes'));
  else // Parent is not a Substitute
    record.append($(target).closest('tr').html()
      .replace(/(\[player_records_attributes\])\[(\d+)\]/g, '$1[$2][sub_record_attributes]')
      .replace(/(_player_records_attributes)_(\d+)/g, '$1_$2_sub_record_attributes'));

  $(target).closest('.item')
    .addClass('hidden')
    .siblings('[data-action="remove"]').addClass('hidden');

  // Set Substitute behavior
  clearBooking($('a[data-action="clear card"]', record));
  $('a[data-action="remove"]', record).removeClass('hidden');
  $('.pos .level.icon', record).last().css('visibility', 'hidden');
  $('.ui.ribbon.label', record).removeClass('yellow');
  $('[data-clickfield] .or', record).attr('data-text', 0);

  // Remove Error classes
  $('.error', record).removeClass('error');

  $.each($('input,select', record), function(){
    $(this).val($(this).data('default'));
  });

  // Append new row to table
  $(target).closest('tr').after(record);
  $('.pos', $(target).closest('tr')).append('<i class="level down red icon"></i>');
  $('.pos', record).append('<i class="level up green icon"></i>');

  // Substitute actions menu was copied weirdly. Hack fix
  $('#view-container .teal.dropdown > .fluid.menu')
    .removeClass('transition visible animating slide down out')
    .attr('style', '');
  $('.ui.dropdown', record).dropdown().dropdown('clear');
}

function removeRecord(target){
  var tr = $(target).closest('tr');
  var parentTr = tr.prev();

  tr.transition({
    animation: 'slide down',
    onComplete: function(){
      if (tr.data('id'))
        $('input[id$="_destroy"]', tr).val(1);
      else
        tr.remove();
        
      $('.ribbon .level.icon', parentTr).last().remove();
      $('a[data-action="add sub"]', parentTr).removeClass('hidden');
      if (parentTr.is('[data-sub]'))
        $('a[data-action="remove"]', parentTr).removeClass('hidden');
    }
  });
}

function addYellowCard(target){
  var yellowCardField = $(target).find('input');
  yellowCardField.val(parseInt(yellowCardField.val()) + 1);
  $(target).find('.floating.label').text(yellowCardField.val());
  $('a[data-action="clear card"]', $(target).closest('.menu')).removeClass('disabled');

  if (yellowCardField.val() > 1)
    addRedCard($(target).closest('.menu').find('a[data-action="red card"]'));
}

function addRedCard(target){
  var redCardField = $(target).find('input');
  redCardField.val(1);
  $(target).find('.floating.label').text('1');
  $('a[data-action="clear card"]', $(target).closest('.menu')).removeClass('disabled');

  $('a[data-action="yellow card"]', $(target).closest('.menu')).addClass('disabled');
  $(target).closest('a[data-action="red card"]').addClass('disabled');
}

function clearBooking(target){
  $('a[data-action="yellow card"] input', $(target).closest('.menu')).val(0);
  $('a[data-action="red card"] input', $(target).closest('.menu')).val(0);

  $('a[data-action="yellow card"], a[data-action="red card"]', $(target).closest('.menu')).removeClass('disabled');
  $('.floating.label', $(target).closest('.menu')).text('0');
  $(target).closest('a[data-action="clear card"]').addClass('disabled');
}

function setMOTM(target){
  var playerId = $('.player_id', $(target).closest('tr')).dropdown('get value');
  if (playerId){
    $('#match_motm_id').val(playerId);
    $('.ui.ribbon.pos').removeClass('yellow');
    $(target).addClass('yellow');        
  }
}