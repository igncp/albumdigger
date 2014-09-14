request = require('request')

module.exports = {
    
  show: (req, res)->
    res.view()

  releasesList: (req, res) ->
    band = encodeURIComponent(req.body.band)
    album = encodeURIComponent(req.body.album)

    url = 'http://api.discogs.com/database/search?type=release&q=' + band + '%20' + album
    request.get({
      url: url
      headers: {'User-Agent': 'AlbumDigger/0.1 +http://albumdigger.hekuapp.com'}
    }, (err, all, data) -> res.json(data))

  release: (req, res) ->
    url = 'http://api.discogs.com/releases/' + req.param('id')
    request.get({
      url: url
      headers: {'User-Agent': 'AlbumDigger/0.1 +http://albumdigger.hekuapp.com',
      'Host': 'api.discogs.com'}
    }, (err, all, data) -> res.json(data))

  videos: (req, res) ->
    band = encodeURIComponent(req.body.bandName)
    album = encodeURIComponent(req.body.albumName)

  search: (req, res)-> res.view('digger/show')
  
  album: (req, res)-> res.view('digger/show')
      
  _config: {}
 
}