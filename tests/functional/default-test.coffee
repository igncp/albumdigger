casper.test.begin('General tests.', (test)->
  (require('../fixtures/common_functional_init'))()

  casper.start(urls.home, ()->
    test.assertEquals(200, casper.status().currentHTTPStatus, 'Page is loaded.')

  )
  
  casper.run(()-> test.done() )
)