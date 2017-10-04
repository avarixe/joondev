$(document).on "turbolinks:load", ->
  $('body.seasons.show table').DataTable
    order: []
    bPaginate: false
