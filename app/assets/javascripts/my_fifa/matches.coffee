highest_rating = undefined

labeledData = (label, data) ->
  '<div class="ui responsive basic right pointing label">' + label + '</div>' + data

$(document).on "turbolinks:load", ->
  $('body.matches.index table').DataTable
    processing: true
    ajax: '/my_fifa/matches'
    order: [ [4, 'desc'] ]
    columns: [
      { data: 'opponent' }
      { data: 'competition' }
      { 
        data: 'score'
        searchable: false
        sortable: false
      }
      { data: 'motm' }
      { 
        data:
          _: 'date_played'
          sort: 'timestamp'
        searchable: false
      }
    ]
    createdRow: (nRow, aData) ->
      $.each [
        'Competition'
        'Score'
        'MOTM'
        'Date Played'
      ], (i, label) ->
        $('td:nth-child(' + (i + 2) + ')', $(nRow)).prepend labeledData(label, '')
        return
      $(nRow).data('id', aData.id).addClass aData.result
      return

  # FORM ONLY JAVASCRIPT
  if $('body').hasClass('new') or $('body').hasClass('edit')

    toggleClickForm = (target) ->
      inputField = $(target).closest('[data-clickfield]').find('input')
      currentValue = parseInt(inputField.val())
      newValue = null
      switch $(target).data('clickaction')
        when 'add'
          newValue = if isNaN(currentValue) then 1 else currentValue + 1
        when 'sub'
          if currentValue > 1 then newValue = currentValue - 1
  
      inputField.val newValue
      $('.or', $(target).closest('[data-clickfield]')).attr 'data-text', newValue or 0
      
      return
  
    addRecord = (target) ->
      # Generate new Record table row
      record = $('<tr data-sub class="transition hidden" />')
      id = moment().valueOf()
      if $('input[id$="pos"]', $(target).closest('tr')).attr('id').indexOf('sub_record') > 0
        record.append $(target).closest('tr').html().
          replace(/(\[sub_record_attributes\])/g, '$1[sub_record_attributes]').
          replace(/(_sub_record_attributes)/g, '$1_sub_record_attributes')
      else # Parent is not a Substitute
        record.append $(target).closest('tr').html().
          replace(/(\[player_records_attributes\])\[(\d+)\]/g, '$1[$2][sub_record_attributes]').
          replace(/(_player_records_attributes)_(\d+)/g, '$1_$2_sub_record_attributes')
  
      $(target).closest('.item')
        .addClass('hidden')
        .siblings('[data-action="remove"]').addClass('hidden')
  
      # Set Substitute behavior
      clearBooking $('a[data-action="clear card"]', record)
      $('a[data-action="remove"]', record).removeClass 'hidden'
      $('.pos .level.icon', record).last().css 'visibility', 'hidden'
      $('.ui.ribbon.label', record).removeClass 'yellow'
      $('[data-clickfield] .or', record).attr 'data-text', 0
  
      # Remove Error classes
      $('.error', record).removeClass 'error'
  
      $.each $('input,select', record), ->
        $(this).val $(this).data('default')
  
      # Append new row to table
      $(target).closest('tr').after record
  
      # Substitute actions menu was copied weirdly. Hack fix
      $('.teal.dropdown > .fluid.menu')
        .removeClass('transition visible animating slide down out')
        .attr('style', '')
      $('.ui.dropdown', record).dropdown().dropdown('clear')
  
      $(record).transition
        animation: 'slide down',
        onComplete: ->
          $('.pos', $(target).closest('tr')).append '<i class="level down red icon"></i>'
          $('.pos', record).append '<i class="level up green icon"></i>'
  
      return
  
    removeRecord = (target) ->
      tr = $(target).closest('tr')
      parentTr = tr.prev()
  
      tr.transition
        animation: 'slide down',
        onComplete: ->
          if tr.data('id')
            $('input[id$="_destroy"]', tr).val 1
          else
            tr.remove
  
          $('.ribbon .level.icon', parentTr).last().remove()
          $('a[data-action="add sub"]', parentTr).removeClass 'hidden'
          if parentTr.is('[data-sub]')
            $('a[data-action="remove"]', parentTr).removeClass 'hidden'
          
          return
      return 
  
    addYellowCard = (target) ->
      yellowCardField = $(target).find('input')
      yellowCardField.val(parseInt(yellowCardField.val()) + 1)
      $(target).find('.floating.label').text yellowCardField.val()
      $('a[data-action="clear card"]', $(target).closest('.menu')).removeClass 'disabled'
      if yellowCardField.val() > 1
        addRedCard $(target).closest('.menu').find('a[data-action="red card"]')
      return
  
    addRedCard = (target) ->
      redCardField = $(target).find('input')
      redCardField.val 1
      $(target).find('.floating.label').text '1'
      $('a[data-action="clear card"]', $(target).closest('.menu')).removeClass 'disabled'
      $('a[data-action="yellow card"]', $(target).closest('.menu')).addClass 'disabled'
      $(target).closest('a[data-action="red card"]').addClass 'disabled'
      return
  
    clearBooking = (target) ->
      $('a[data-action="yellow card"] input', $(target).closest('.menu')).val 0
      $('a[data-action="red card"] input', $(target).closest('.menu')).val 0
      $('a[data-action="yellow card"], a[data-action="red card"]', $(target).closest('.menu')).removeClass 'disabled'
      $('.floating.label', $(target).closest('.menu')).text '0'
      $(target).closest('a[data-action="clear card"]').addClass 'disabled'
      return
  
    setMOTM = (target) ->
      playerId = $('.player_id', $(target).closest('tr')).dropdown('get value')
      if playerId
        $('#match_motm_id').val playerId
        $('.ui.ribbon.pos').removeClass 'yellow'
        $(target).addClass 'yellow'
      return


    $('#match_opponent, #match_competition').dropdown
      placeholder: false
      allowAdditions: true
      hideAdditions: false
  
    $('.pusher').on 'click', '[data-clickfield] a[data-clickaction]', -> toggleClickForm this
    $('.pusher').on 'click', 'a[data-action]',               -> $(this).removeClass 'active selected'
    $('.pusher').on 'click', 'a[data-action="add sub"]',     -> addRecord this
    $('.pusher').on 'click', 'a[data-action="remove"]',      -> removeRecord this
    $('.pusher').on 'click', 'a[data-action="yellow card"]', -> addYellowCard this
    $('.pusher').on 'click', 'a[data-action="red card"]',    -> addRedCard this
    $('.pusher').on 'click', 'a[data-action="clear card"]',  -> clearBooking this
  
    # By default, highest rating gets MOTM
    highest_rating = $('input.rating').map(-> @value).get().sort().pop() or 0
  
    $('table').on 'input', '.rating', ->
      if parseFloat(@value) > parseFloat(highest_rating)
        highest_rating = @value
        setMOTM $('.ui.ribbon.pos', $(this).closest('tr'))
  
    # Clicking a ribbon label sets MOTM
    $('table').on 'click', '.ui.ribbon.pos', -> setMOTM this
  
    # Squad auto populates players and positions
    $('select[id$="squad_id"]').change ->
      if $(this).val()
        $.get '/my_fifa/squads/' + $(this).val() + '/info', (data) ->
          $.each data.player_ids, (i, player_id) ->
            tr = $('#match_player_records_attributes_' + i + '_pos').closest('tr')
            $('select[id$="player_id"]', tr).dropdown 'set selected', player_id

            # Update Position labels
            $('td:first-child input', tr).attr('data-default', data.positions[i]).val data.positions[i]
            $('td:first-child .ribbon span', tr).text data.positions[i]
            return
          return
        $('#update-squad-btn').attr 'disabled', false
      else
        $('#update-squad-btn').attr 'disabled', true
      return

    $('#update-squad-btn').click (evt) ->
      evt.preventDefault()
      squadId = $('select[id$="squad_id"]').val()
      rows = $('table tbody tr')
      squadParams = {}
      i = 0
      while i < 11
        squadParams['player_id_' + i + 1] = $('.player_id', $(rows[i])).dropdown('get value')
        i++
      $.ajax
        url: '/my_fifa/squads/' + squadId
        type: 'PUT'
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-CSRF-Token', AUTH_TOKEN
          return
        data:
          squad: squadParams
          page: 'match'
      return

  return