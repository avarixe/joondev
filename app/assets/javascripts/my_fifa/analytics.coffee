table = undefined

labeledData = (label, data) ->
  '<div class="ui responsive basic right pointing label">' + label + '</div>' + data

$(document).on "turbolinks:load", ->
  $('body.analytics.players #season, body.analytics.players #competition').change -> table.ajax.reload()
  
  table = $('body.analytics.players table').DataTable(
    order: [ [3, 'desc'] ]
    ajax:
      url: '/my_fifa/analytics/players'
      data: (d) ->
        d.season = $('select#season').val()
        d.competition = $('select#competition').val()
        return
      dataSrc: (json) ->
        $.each json.data, (i, data) -> json.data[i].rank = data.gp * data.rating + 3 * data.goals + data.assists + data.cs
        json.data
    processing: true
    columns: [
      { data: 'name' }
      { data: 'pos' }
      { data: 'gp' }
      { data:
          _: 'rating'
          sort: 'rank'
        render: $.fn.dataTable.render.number(',', '.', '2')
      }
      { data: 'goals' }
      { data: 'assists' }
      { data: 'cs' }
    ]
    createdRow: (nRow, aData) ->
      $.each [
        'Position'
        'GP'
        'Rating'
        'Goals'
        'Assists'
        'CS'
      ], (i, label) -> $('td:nth-child(' + (i + 2) + ')', $(nRow)).prepend labeledData(label, '')
      if !aData.active
        $('td:first-child', $(nRow)).prepend '<i class="red attention icon"></i>'
        $(nRow).addClass 'disabled'
      return
  )
  return