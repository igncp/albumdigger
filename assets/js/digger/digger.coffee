$ = jQuery

ready = ->
  allLoaded = ()->
    app.router = new app.extends.Router()

  async.parallel([
    (end)-> $.getScript('/js/digger/digger-models.js', ()->end())
    (end)-> $.getScript('/js/digger/digger-views.js', ()-> end())
    (end)-> $.getScript('/js/digger/digger-router.js', ()-> end())
  ], allLoaded)

$(document).ready(ready)