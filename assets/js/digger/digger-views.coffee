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
Backbone.View::goBack = ((e)->
  e.preventDefault()
  app.back = true
  window.history.back()
)


class app.extends.ViewReleaseRow extends Backbone.View
  tagName: 'li',
  
  template: _.template($('#release-row').html()),
  
  render: ->
    @$el.html(@template(@model.attributes))
    this
  
  events:
    'click .release-link': 'selectRelease'
  
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
  template: _.template($('#releases-list').html())
  render: ( ->
    view = this
    app.removeAllViews()
    @el.innerHTML = @template({result_count: @collection.length})
    @collection.each((model)->
      release = new app.extends.ViewReleaseRow({ model: model })
      view.$el.find('.list').append(release.el)
    )
    @$el.fadeIn(3000)
  )

  events:
    'click .back': 'goBack'


class app.extends.ViewRelease extends Backbone.View
  el: '.singleRelease'
  template: _.template($('#release').html())
  
  render: -> @$el.html(@template(@model.attributes)).fadeIn(3000)

  events:
    'click .back': 'goBack'


app.views.searchForm = new (Backbone.View.extend({
  el: '#search-form'
  
  initialize: -> null
  
  render: -> @$el.fadeIn(1000)

  events:
    'click #submitter': 'submitInfo'
  
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

}))()