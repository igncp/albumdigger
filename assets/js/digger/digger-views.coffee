app = app or {}
app.extends = app.extends or {}
app.extends.charts = app.extends.charts or {}
app.views = {}

app.removeAllViews = ( ->
  _.each(app.views, (viewContent, view)->
    app.views[view].hide() if view isnt 'submitButton' and view isnt 'header'
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
    app.removeAllViews()
    app.router.navigate('album?id=' + @model.get('id'), {trigger: true})
  )


class app.extends.ViewReleasesList extends Backbone.View
  el: '#releases',
  template: _.template($('#releases-list').html())
  render: ( ->
    view = this
    @collection.off('filterChange')
    @collection.on('filterChange', view.render, view)
    app.removeAllViews()
    @el.innerHTML = @template({result_count: view.collection.size(), search_strings: app.params})
    @$el.find('input[value="' + view.collection.currentFilter + '"]').attr('checked', 'checked')
      .parent().addClass('active')
    five = @collection.first(5)
    five.forEach((model)->
      release = new app.extends.ViewReleaseRow({ model: model })
      view.$el.find('.list-five').append(release.el)
    )
    if @collection.length > 5
      @$el.find('.list-rest').append('<p><strong>Rest of the results</strong></p>')
      @collection.each((model, index)->
        if index > 4
          release = new app.extends.ViewReleaseRow({ model: model })
          view.$el.find('.list-rest').append(release.el)
      )
    app.views.chartLabels = new app.extends.charts.ChartLabels({collection: view.collection})
    app.views.chartMap = new app.extends.charts.ChartMap({collection: view.collection})
    app.views.chartStyles = new app.extends.charts.ChartStyles({collection: view.collection})
    app.views.chartYears = new app.extends.charts.ChartYears({collection: view.collection})

    @$el.fadeIn(3000)
  )

  events:
    'click .back': 'goBack'
    'click .toggle-charts': 'toggleCharts'
    'change input[name="filter"]': 'filterData'

  toggleCharts: ((e)->
    e.preventDefault()
    if $('#charts').is(':visible')
      $('.toggle-charts a').text('Show Charts')
      $('#charts').fadeOut(1000)
      $('.toggle-charts').animate({top: '-20px', right: '10px'}, 1000, 'linear')
    else
      $('.toggle-charts a').text('Hide Charts')
      $('#charts').fadeIn(1000)
      $('.toggle-charts').animate({top: '0px', right: '60px'}, 1000)
  )

  filterData: -> @collection.filterChange(@$el.find('input[name="filter"]:checked').val())
  


class app.extends.ViewRelease extends Backbone.View
  el: '.singleRelease'
  template: _.template($('#release').html())
  
  render: ->
    # app.removeAllViews()
    @$el.html(@template(@model.attributes)).fadeIn(3000)

  events:
    'click .back': 'goBack'


app.views.searchForm = new (Backbone.View.extend({
  el: '#search-form'
  render: -> @$el.fadeIn(1000)
  initialize: -> null

  events:
    'click #submitter': 'submitInfo'
  
  submitInfo: ((e)->
    e.preventDefault()
    view = @
    @validate( ->
      view.hide()
      app.router.navigate('search?band=' + $('#band-name').val() +
        '&album=' + $('#album-name').val(), {trigger: true})
    )
  )

  validate: ((cb)->
    if $('#band-name').val() != '' and $('#album-name').val()
      cb()
    else
      duration = 1000
      message = @$el.find('#validation-error-message')
      message.stop().clearQueue().fadeTo(duration, 1, ->
        message.delay(3000).fadeTo(duration,0)
      )
  )

}))()

generateChartData = ((collection, property, chart)->
  data = collection.groupBy(property)
  data = _.keys(data).map((key, index)->
    obj = {}
    obj.count = data[key].length
    obj[property] = (-> if key is 'undefined' then return 'None' else return key)()
    obj
  )
  data = _.sortBy(data, 'count').reverse() if property isnt 'year'
  app.extends.charts.generates[chart](data)
)

app.extends.charts.ChartYears = Backbone.View.extend({
  render: -> generateChartData(@collection, 'year', 'generateChartYears')
})

app.extends.charts.ChartLabels = Backbone.View.extend({
  render: -> generateChartData(@collection, 'label', 'generateChartLabels')
})

app.extends.charts.ChartStyles = Backbone.View.extend({
  render: -> generateChartData(@collection, 'style', 'generateChartStyles')
})

app.extends.charts.ChartMap = Backbone.View.extend({
  render: -> generateChartData(@collection, 'country', 'generateChartMap')
})

app.views.header = new (Backbone.View.extend({
  el: 'header'
  initialize: -> null

  events:
    'click a': 'goToIndex'
  
  goToIndex: ((e)->
    e.preventDefault()
    app.router.navigate('/', {trigger: true})
  )

}))()