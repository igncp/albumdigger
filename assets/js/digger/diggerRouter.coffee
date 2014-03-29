app = app || {}
app.extends = app.extends || {}

app.extends.Router = Backbone.Router.extend({
    initialize: ()->
        Backbone.history.start({pushState: true})

    routes: {
        "":"index"
        "search?band=:band&album=:album" : "search"
    },

    search: (band,album)->
        data = {}
        data.bandName = band;  data.albumName = album
        $.ajax({url: '/releases/', type: 'POST', data: data}).done((data)->
            releases = JSON.parse(data)
            releasesCollection = new app.extends.CollectionReleases(releases.results)
            app.views.releasesList = new app.extends.ViewReleasesList(collection: releasesCollection)
        )
    
    index: ()->
        app.removeAllViews()
        app.captcha.setCaptcha()
        app.views.submitButton = new app.extends.ViewSubmit()
})

app.captcha = {}

app.captcha.setCaptcha = ()->
    app.captcha.ops = ['+','-']
    app.captcha.first = _.random(0,9); app.captcha.second =  _.random(0,9)
    app.captcha.opIndex = _.random(0,1)
    $('#captchaOperation').html(app.captcha.first + ' ' + app.captcha.ops[app.captcha.opIndex] + ' ' + app.captcha.second + ' = ...')