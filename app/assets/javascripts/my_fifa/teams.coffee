$(document).on "turbolinks:load", ->
  $('body.teams.index .ui.checkbox').checkbox
    uncheckable: false
    onChecked: ->
      this_ = this
      $.ajax
        type: 'POST'
        url: '/my_fifa/teams/' + this_.value + '/set_active'
        beforeSend: (xhr) -> xhr.setRequestHeader 'X-CSRF-Token', AUTH_TOKEN
      return
  return