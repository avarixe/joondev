$(document).on "turbolinks:load", ->

  # JoonDEV sidebar
  $('div.sidebar').sidebar(transition: 'overlay').sidebar('attach events', '.toggle.button').sidebar 'hide'

  Mousetrap.bind 'alt+j', -> 
    $('div.sidebar').sidebar 'toggle'
    return

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind 'ajax:error', (evt, data, status, xhr) ->
    alert 'Invalid Value Entered.'

  $('.menu[data-menu="tabs"] .item').tab
      onLoad: ->
        Chartkick.eachChart (chart) ->
          chart = arguments[0].chart
          $.each chart.series, (i) ->
            chart.series[i].options.lineWidth = 1.5
            chart.series[i].options.point.events = click: (e) -> 
              chartContainer = $(e.target).closest('.chart.container')
              if chartContainer.data('link')
                window.open chartContainer.data('link').replace('{id}', chartContainer.data('ids')[i][e.point.index])

  # Dropdown menus
  $('select.dropdown:not(.custom), .ui.dropdown:not(.custom)').dropdown({
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
    $(this).closest('.message').transition 
      animation: 'fade'
      onComplete: -> $(this).closest('.message').remove()

  $('[data-flatpickr]').flatpickr({
    altInput: true,
    altFormat: "M j, Y",
    onOpen: (selectedDates, dateStr, instance) ->
      console.log($(instance.element).data("default"))
      if dateStr.length == 0 and $(instance.element).data("default")
        instance.setDate($(instance.element).data("default"))
      return
  });

  # Input Masks
  $('[data-inputmask]').inputmask()

  # Custom Accordion Functionality
  $('.accordion .title').off 'click'
  $('.accordion .title').on 'click', ->
    $(this).toggleClass("active")
      .next(".content").transition "slide down"
    return

  # Tables with links are clickable
  $('html').on 'mousedown', 'table tr', (evt) ->
    $(this).data('p0', { x: evt.pageX, y: evt.pageY })
    return
  $('html').on 'mouseup', 'table tr', (evt) ->
    switch evt.which
      when 1
        p0 = $(this).data('p0')
        p1 = { x: evt.pageX, y: evt.pageY }
        d = Math.sqrt(Math.pow(p1.x - p0.x, 2) + Math.pow(p1.y - p0.y, 2))

        if d < 4 and
          (_link = $(evt.target).closest('table').data('link')) and 
          (_rowId = $(evt.target).closest('tr').data('id')) and 
          !$(evt.target).is('.button, i') and
          !$(evt.target).closest('td').is('[no-link]')
            if evt.ctrlKey or evt.metaKey or $(evt.target).closest('table').is('[target-blank]')
              window.open _link + _rowId
            else
              window.location = _link + _rowId
    return