$(document).on "turbolinks:load", ->
  $('body.players.index table').DataTable
    order: []