organizePositions = ->
  if $('#formation_layout').length == 0
    return
  
  layout = $('#formation_layout').val().split('-').map((n) ->
    parseInt n
  )
  rows = [ [] ]
  nRow = 0
  posInRow = 0 # current row index
  pos = 2      # counter of pos in currow row
  while pos <= 11
    # If reached threshold of row, create next row
    if rows[nRow].length == layout[nRow]
      nRow++
      rows.push []
    rows[nRow].push pos
    pos++
  # Clear the grid of the previous layout
  $('.field.pos[data-no != 1]').appendTo '#positions-container'
  $('.grid > .row:not(:last-child)').remove()
  # Repopular the grid with row data
  i = 0
  while i < rows.length
    rowClass = (if rows[i].length % 2 == 0 then 'four' else 'five') + ' columns centered row'
    # Collect rows in container
    rowElem = $('<div class="' + rowClass + '"></div>')
    j = 0
    while j < rows[i].length
      $('#positions-container .field[data-no=' + rows[i][j] + ']').appendTo rowElem
      j++
    # Add row to stackable grid
    $('.ui.stackable.grid').prepend rowElem
    i++
  $('.ui.stackable.grid').transition 'pulse'
  return

$(document).on "turbolinks:load", ->
  organizePositions()
  $(this).change ->
    organizePositions()
    return
  return
