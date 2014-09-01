casper.test.begin('General tests.', (test)->
  (require('../fixtures/common_functional_init'))()

  casper.start(urls.home, ()->
    test.assertHttpStatus(200, 'Page is loaded.')
    this.fill('form', fixtures.search, false)
    this.click('#submitter')

  ).waitUntilVisible('ul#releases').then(()->
    test.assertEval((()-> $('ul#releases li').length > 0), 'It loads albums.')
    this.click('ul#releases li:last-child .release-link')
    
  ).waitUntilVisible('.singleRelease').then(()->
    test.assertVisible('.singleRelease', 'The single release is visible.')
    test.assertEval((()-> $('.singleRelease').html().trim() != ''),
      'The single release is not empty.')
  )
  
  casper.run(()-> test.done() )
)