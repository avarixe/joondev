$(document).on "turbolinks:load", ->
  # JoonDEV sidebar
  $('div.sidebar').sidebar(transition: 'overlay').sidebar('attach events', '.toggle.button').sidebar 'hide'

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind 'ajax:error', (evt, data, status, xhr) ->
    alert 'Invalid Value Entered.'


  $('.menu[data-menu="tabs"] .item').tab
      onLoad: ->
        Chartkick.eachChart (chart) ->
          chart = arguments[0].chart
          chart.series[0].options.lineWidth = 1.5
          chart.series[0].options.point.events = click: (e) -> 
            chartContainer = $(e.target).closest('.chart.container')
            if chartContainer.data('link')
              window.open chartContainer.data('link').replace('{id}', chartContainer.data('ids')[e.point.index])

  # Dropdown menus
  $('select.dropdown:not(.addable), .ui.dropdown:not(.addable)').dropdown({
    placeholder: false
  });
    
  # Dropdown menu support for grouped selects
  $('.ui.dropdown').has('optgroup').each ->
      $menu = undefined
      $menu = $('<div/>').addClass('menu')
      $(this).find('select > option').each ->
        $menu.append '<div class="item" data-value="">' + @innerHTML + '</div>'
      $(this).find('optgroup').each ->
        $menu.append '<div class="ui horizontal divider">' + @label + '</div>'
        $(this).children().each ->
          $menu.append '<div class="item" data-value="' + @value + '">' + @innerHTML + '</div>'
      $(this).find('.menu').html $menu.html()

  $('html').on 'click', '.message .close', ->
    $(this).closest('.message').transition 'fade'
    return
    
  $('[data-flatpickr]').flatpickr({
    altInput: true,
    altFormat: "M j, Y"
  });

  # Input Masks
  $('[data-inputmask]').inputmask()

  # Tables with links are clickable
  $('html').on 'click', 'table tbody tr', (evt) ->
    if (_link = $(this).closest('table').data('link')) and 
      (_rowId = $(this).data('id')) and 
      !$(evt.target).is('.button, i') and
      !$(evt.target).closest('td').is('[no-link]')
        if evt.ctrlKey or evt.metaKey
          window.open _link + _rowId
        else
          window.location = _link + _rowId
    return