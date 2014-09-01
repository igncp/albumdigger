app = app or {}
app.extends = app.extends or {}
app.models = app.models or {}

app.extends.Router = Backbone.Router.extend({
  initialize: -> Backbone.history.start({pushState: true})

  routes: {
    '': 'index'
    'search?band=:band&album=:album': 'search'
    'album?id=:id': 'release'
  }

  search: ((band,album)->
    data = {}
    data.bandName = band
    data.albumName = album

    app.removeAllViews()
    
    if app.back is true
      app.back = false
      app.views.releasesList = new app.extends.ViewReleasesList({collection: app.models.releases})

    else
      $.ajax({url: '/releases/', type: 'POST', data: data}).done((data)->
        releases = JSON.parse(data)
        app.models.releases = new app.extends.CollectionReleases(releases.results)
        app.views.releasesList = new app.extends.ViewReleasesList({collection: app.models.releases})
      )
  )
  
  index: ( ->
    app.removeAllViews()
    app.views.submitButton = new app.extends.ViewSubmit()
  )

  release: ( ->
    app.views.releasesList.hide()
    app.views.release = new app.extends.ViewRelease({model: app.models.release})
  )

})