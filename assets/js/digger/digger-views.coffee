app = app or {}
app.extends = app.extends or {}
app.views = {}

app.removeAllViews = ( ->
  _.each(app.views, (viewContent, view)->
    app.views[view].hide() if view != 'submitButton'
  )
)

Backbone.View::hide = -> @$el.hide()
Backbone.View::initialize = -> @render()

app.extends.ViewSubmit = Backbone.View.extend({
  el: '#submitter'
  
  events:
    'click': 'submitInfo'
  
  submitInfo: ((e)->
    e.preventDefault()
    @validate( ->
      app.router.navigate('search?band=' + $('#band-name').val() +
        '&album=' + $('#album-name').val(), {trigger: true})
    )
  )

  validate: ((cb)->
    if $('#band-name').val() != '' and $('#album-name').val() then cb()
    else return
  )
})


class app.extends.ViewReleaseRow extends Backbone.View
  tagName: 'li',
  
  template: _.template($('#releaseRow').html()),
  
  events:
    'click .release-link': 'selectRelease'
  
  render: -> @$el.html(@template(@model.attributes))
  
  selectRelease: ((e)->
    e.preventDefault()
    @model.fetch({success: (model, data)->
      album = JSON.parse(data)
      app.models.release = new app.extends.ModelRelease(album)
      app.router.navigate('album?id=' + album.id, {trigger: true})
    })
  )



class app.extends.ViewReleasesList extends Backbone.View
  el: '#releases',

  render: ( ->
    view = this
    @$el.html('<p><strong>Results:</strong> ' + @collection.length + '</p>').fadeIn(3000)
    @collection.each((model)->
      releaseList = new app.extends.ViewReleaseRow({ model: model })
      view.$el.append(releaseList.el)
    )
    @$el.append('<p><strong>Discogs search <a href="http://api.discogs.com" ' +
      'target="_blank">API</a></strong></p>')
  )


class app.extends.ViewRelease extends Backbone.View
  el: '.singleRelease'
  template: _.template($('#release').html())
  
  render: -> @$el.html(@template(@model.attributes)).fadeIn(3000)

  events:
    'click .release-back': 'goBack'

  goBack: ((e)->
    e.preventDefault()
    app.back = true
    window.history.back()
  )