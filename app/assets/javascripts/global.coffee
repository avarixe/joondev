window.App ||= {}

App.init = ->
  # JoonDEV sidebar
  $('div.sidebar').sidebar(transition: 'overlay').sidebar('attach events', '.toggle.button').sidebar 'hide'

  # Dropdown menus
  $('select.dropdown, .ui.dropdown').dropdown()
    
  # Dropdown menu support for grouped selects
  $('.ui.dropdown').has('optgroup').each ->
      $menu = undefined
      $menu = $('<div/>').addClass('menu')
      $(this).find('optgroup').each ->
        $menu.append '<div class="header">' + @label + '</div><div class="divider"></div>'
        $(this).children().each ->
          $menu.append '<div class="item" data-value="' + @value + '">' + @innerHTML + '</div>'
      $(this).find('.menu').html $menu.html()

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

$(document).on "turbolinks:load", ->
  App.init()