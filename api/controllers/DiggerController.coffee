googleapis = require 'googleapis'
request = require 'request'

module.exports = {
    
    show: (req, res) ->
        res.view()
    releasesList: (req, res) ->
        band = encodeURIComponent(req.body.bandName)
        album = encodeURIComponent(req.body.albumName)
        url = 'http://api.discogs.com/database/search?type=release&q=' + band + '+' + album
        request.get({url:url,headers: {'User-Agent': 'node-album-app: still without url'}}, (err, all, data) -> res.json(data) )

    release: (req, res) ->
        url = 'http://api.discogs.com/release/' + req.params.id
        request.get({url:url,headers: {'User-Agent': 'node-album-app: still without url', 'Host': "api.discogs.com"}}, (err, all, data) -> res.json(data) )

    videos: (req, res) ->
        band = encodeURIComponent(req.body.bandName)
        album = encodeURIComponent(req.body.albumName)

    search: (req, res)->
        res.redirect('/');
        
    _config: {}
 
}