app = app || {}
app.extends = app.extends || {}

app.extends.Router = Backbone.Router.extend({
  initialize: ()-> Backbone.history.start({pushState: true})

  routes: {
    '': 'index'
    'search?band=:band&album=:album': 'search'
  }

  search: ((band,album)->
    data = {}
    data.bandName = band
    data.albumName = album
    
    $.ajax({url: '/releases/', type: 'POST', data: data}).done((data)->
      releases = JSON.parse(data)
      releasesCollection = new app.extends.CollectionReleases(releases.results)
      app.views.releasesList = new app.extends.ViewReleasesList({collection: releasesCollection})
    )
  )
  
  index: (()->
    app.removeAllViews()
    app.views.submitButton = new app.extends.ViewSubmit()
  )

})