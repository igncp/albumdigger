app = app or {}
app.extends = app.extends or {}

class app.extends.ModelReleaseRow extends Backbone.Model
  urlRoot: 'release'
  initialize: ( ->
    @set('label', @get('label')[0]) if @get('label')
  )

class app.extends.CollectionReleases extends Backbone.Collection
  model: app.extends.ModelReleaseRow
  initialize: (data)->
    @initialObjects = data
    @currentFilter = 'filter-none'

  filterChange: ((filter)->
    @currentFilter = filter
    newModels = []
    band = unescape(app.params.band).toLowerCase()
    album = unescape(app.params.album).toLowerCase()

    if filter is 'filter-none' then newModels = @initialObjects
    else if filter is 'filter-band'
      _.each(@models, (model)->
        if model.get('title').toLowerCase().match(band) then newModels.push model
      )
    else if filter is 'filter-all'
      _.each(@models, (model)->
        title = model.get('title').toLowerCase()
        if title.match(band) and title.match(album) then newModels.push model
      )

    @reset(newModels)

    @trigger('filterChange')
  )


class app.extends.ModelRelease extends Backbone.Model
  initialize: ( ->
    self = this
    _.each(this.attributes.tracklist,(track, index)->
      self.attributes.tracklist[index].videoLink = \
        '<a href="http://www.youtube.com/results?search_query=' +
        encodeURI(track.title) + '+' +
        encodeURI(self.attributes.artists[0].name) +
        '" target="_blank">Video</a> '

      self.attributes.tracklist[index].lyricsLink = \
        '<a href="http://songmeanings.com/query/?type=songtitles&query=' +
        encodeURI(track.title) + '+' + encodeURI(self.attributes.artists[0].name) +
        '" target="_blank">Lyrics</a>'
    )
  )