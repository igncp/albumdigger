app = app || {}
app.extends = app.extends || {}
app.views = {}

app.removeAllViews = ()->
    _.each(app.views, (viewContent, view)->
        app.views[view].hide() if view != 'submitButton'
    )

app.extends.ViewSubmit = Backbone.View.extend({
    el:'#submitter',
    events: {
        'click': 'submitInfo'
    },
    submitInfo: (e)->
        e.preventDefault()
        this.validateCaptcha(()->
            app.router.navigate('search?band=' + $('#band-name').val() + '&album=' + $('#album-name').val(), {trigger: true})
        )

    validateCaptcha: (cb)->
        if app.captcha.opIndex == 1 then second = (app.captcha.second * -1) else second = app.captcha.ops
        result = app.captcha.first + second
        input = parseInt( $('#captcha').val() )
        if result == input
            cb()
        else
            $('.alert').html('Wrong captcha').alert()
            
            console.log 'alert'
})

app.extends.ViewReleaseRow = Backbone.View.extend({
    tagName: 'li',
    template: _.template($('#releaseRow').html()),
    events: {
        'click .release-link': 'selectRelease'
    }
    initialize: ()->
        this.render()
    render: ()->
        this.$el.html(this.template(this.model.attributes))
    selectRelease: (e)->
        e.preventDefault()
        this.model.fetch({success: (model, data)->
            app.views.releasesList.hide()
            release = new app.extends.ModelRelease(JSON.parse(data).resp.release)
            app.views.release = new app.extends.ViewRelease({model: release})
        })
})

app.extends.ViewReleasesList = Backbone.View.extend({
    el: '#releases',
    initialize: ()-> this.render()
    render: ()->
        view = this;
        this.$el.html('<p>Discogs search: (<a href="http://api.discogs.com" target="_blank">API</a>)</p>').fadeIn(3000)
        this.collection.each((model)-> 
            releaseList = new app.extends.ViewReleaseRow({ model: model })
            view.$el.append releaseList.el
        )
    hide: ()->
        this.$el.hide()
})

app.extends.ViewRelease = Backbone.View.extend({
    el: '.singleRelease',
    #template: _.template(app.templates.release),
    template: _.template($('#release').html()),
    initialize: ()->
        this.render()
    render: ()->
        this.$el.html(this.template(this.model.attributes)).fadeIn(3000)
    hide: ()->
        this.$el.hide()
})