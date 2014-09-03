app = app or {}
app.extends = app.extends or {}

class app.extends.ModelReleaseRow extends Backbone.Model
  urlRoot: 'release'
  initialize: ( ->
    this.set('label', this.get('label')[0]) if this.get('label')
  )

class app.extends.CollectionReleases extends Backbone.Collection
  model: app.extends.ModelReleaseRow


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