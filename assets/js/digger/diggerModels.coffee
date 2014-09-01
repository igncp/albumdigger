app = app || {}
app.extends = app.extends || {}

app.extends.ModelReleaseRow = Backbone.Model.extend({
  urlRoot: 'release'
})

app.extends.CollectionReleases = Backbone.Collection.extend({
  model: app.extends.ModelReleaseRow
})

app.extends.ModelRelease = Backbone.Model.extend({
  initialize: ()->
    self = this
    _.each(this.attributes.tracklist,(track, index)->
      self.attributes.tracklist[index].videoLink = '<a href="http://www.youtube.com/results?search_query=' + encodeURI(track.title) + '+' + encodeURI(self.attributes.artists[0].name) + '" target="_blank">Video</a> '
      self.attributes.tracklist[index].lyricsLink = '<a href="http://songmeanings.com/query/?type=songtitles&query=' + encodeURI(track.title) + '+' + encodeURI(self.attributes.artists[0].name) + '" target="_blank">Lyrics</a>'
    )
  })