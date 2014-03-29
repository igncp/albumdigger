$ = jQuery

ready = ->
    allLoaded = ()->
        app.router = new app.extends.Router()
        setHeight()

    async.parallel([
        (end)-> $.getScript('js/digger/diggerModels.js', ()->end()),
        (end)-> $.getScript('js/digger/diggerViews.js', ()-> end()),
        (end)-> $.getScript('js/digger/diggerRouter.js', ()-> end())
    ], allLoaded)

$(document).ready(ready)

setHeight = ()->
    currentHeight = $('#content').outerHeight()
    differenceHeight = $(window).height() - currentHeight
    if (differenceHeight - 2*150) > 0
        newHeight = Math.floor(differenceHeight / 2) - 2
        $('.sky-background').height(newHeight)