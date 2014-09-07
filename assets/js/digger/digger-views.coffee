app = app or {}
app.extends = app.extends or {}
app.extends.charts = app.extends.charts or {}
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
    app.views.chartYears = new app.extends.charts.ChartYears({collection: view.collection})
    app.views.chartLabels = new app.extends.charts.ChartLabels({collection: view.collection})
    app.views.chartStyles = new app.extends.charts.ChartStyles({collection: view.collection})

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
    app.removeAllViews()
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
    @validate( ->
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

app.extends.charts.ChartYears = Backbone.View.extend({
  render: ->
    data = @collection.groupBy('year')
    data = _.keys(data).map((key, index)-> {
      year: (-> if key is 'undefined' then return 'None' else return key)()
      count: data[key].length
    })
    app.extends.charts.generates.generateChartYears(data)
})

app.extends.charts.ChartLabels = Backbone.View.extend({
  render: ->
    data = @collection.groupBy('label')
    data = _.keys(data).map((key, index)-> {
      label: (-> if key is 'undefined' then return 'None' else return key)()
      count: data[key].length
    })
    data = _.sortBy(data, 'count').reverse()
    app.extends.charts.generates.generateChartLabels(data)
})

app.extends.charts.ChartStyles = Backbone.View.extend({
  render: ->
    data = @collection.groupBy('style')
    data = _.keys(data).map((key, index)-> {
      style: (-> if key is 'undefined' then return 'None' else return key)()
      count: data[key].length
    })
    data = _.sortBy(data, 'count').reverse()
    app.extends.charts.generates.generateChartStyles(data)
})