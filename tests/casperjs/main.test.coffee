base_url = 'http://localhost:4000'
urls = {}
urls.main = base_url

casper.test.begin('First form.', (test)->
    casper.start(urls.main,()->).then(()->
        this.waitUntilVisible('input#submitter', ()->
            this.click('input#submitter')
        , ()->
            console.log 'not visible'
        )
    ).then(()->
        content = this.getHTML()
        # test.assertMatch(content, /Wrong\ captcha/i, 'Captcha stops form submitting.');
    )
    
    casper.run(()-> test.done() )
)