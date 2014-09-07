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
    app.params = {band: band, album: album}
    
    if app.back is true
      app.back = false
      app.views.releasesList.render()

    else
      $.ajax({url: '/releases/', type: 'POST', data: app.params}).done((data)->
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
      )
  )
  
  index: ( ->
    if app.back is true then app.back = false
    app.removeAllViews()
    app.views.searchForm.render()
  )

  release: ( ->
    app.views.releasesList.hide()
    app.views.release = new app.extends.ViewRelease({model: app.models.release})
  )

})

queryString = ( ->
  query_string = {}
  query = window.location.search.substring(1)
  vars = query.split('&')
  for i in [0...vars.length]
    pair = vars[i].split('=')

    if typeof query_string[pair[0]] is 'undefined'
      query_string[pair[0]] = pair[1]
    else if typeof query_string[pair[0]] is 'string'
      arr = [ query_string[pair[0]], pair[1] ]
      query_string[pair[0]] = arr
    else
      query_string[pair[0]].push(pair[1])
  
  query_string
)