app = app or {}
app.extends = app.extends or {}
app.models = app.models or {}

# http://fgnass.github.io/spin.js/
spinnerOpts = {
  lines: 17, length: 10, width: 2, radius: 10, corners: 1.0, rotate: 0, trail: 25,
  speed: 1.2, direction: 1
}

# Ends any previous ajax request and deletes the spinner.
app.stopAjax = ( ->
  if app.spinner
    app.spinner.stop()
    delete app.spinner
  if app.ajax
    app.ajax.abort()
    delete app.ajax
)

app.extends.Router = Backbone.Router.extend({
  initialize: -> Backbone.history.start({pushState: true})

  routes: {
    '': 'index'
    'search?band=:band&album=:album': 'search'
    'album?id=:id': 'release'
  }

  search: ((band,album)->
    app.stopAjax()
    app.params = {band: band, album: album}
    
    if app.back is true and app.views.releasesList?
      app.back = false
      app.views.releasesList.render()

    else
      app.spinner = new Spinner(spinnerOpts).spin(document.getElementById('content'))
      app.ajax = Backbone.ajax({url: '/releases/', type: 'POST', data: app.params, success: (data)->
        app.spinner.stop()
        releases = JSON.parse(data)
        # console.log releases
        app.models.releases.remove() if app.models.releases
        app.models.releases = new app.extends.CollectionReleases(releases.results)
        
        if app.views.releasesList
          app.views.releasesList.collection = app.models.releases
          app.views.releasesList.render()
        else
          app.views.releasesList = new \
            app.extends.ViewReleasesList({collection: app.models.releases})
      })
  )
  
  index: ( ->
    app.stopAjax()

    # To be able to use app.back in the search route.
    if app.back is true then app.back = false
    
    app.removeAllViews()
    app.views.searchForm.render()
  )

  release: ( (id)->
    app.stopAjax()
    app.spinner = new Spinner(spinnerOpts).spin(document.getElementById('content'))
    app.ajax = Backbone.ajax({
      url: "/release/#{id}"
      success: (data)->
        app.spinner.stop()
        album = JSON.parse(data)
        app.models.release = new app.extends.ModelRelease(album)
        app.views.release = new app.extends.ViewRelease({model: app.models.release})
      }
    )
  )

})