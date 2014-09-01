$ = jQuery

ready = ->
  allLoaded = ()->
    app.router = new app.extends.Router()

  async.parallel([
    (end)-> $.getScript('/js/digger/diggerModels.js', ()->end())
    (end)-> $.getScript('/js/digger/diggerViews.js', ()-> end())
    (end)-> $.getScript('/js/digger/diggerRouter.js', ()-> end())
  ], allLoaded)

$(document).ready(ready)