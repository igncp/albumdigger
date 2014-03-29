base_url = 'http://localhost:4000/'
urls = {}
urls.main = base_url

casper.test.begin('First form.', (test)->
    casper.start(urls.main,()->).then(()->
        this.waitUntilVisible('input#submitter', ()->
            this.click('input#submitter')
        , ()->console.log 'not visible'
        )
    ).then(()->
        test.assertEquals(this.getCurrentUrl(), urls.main, 'Forms validates correctly.');
    )
    
    casper.run(()-> test.done() )
)