casper.test.begin('General tests.', (test)->
  (require('../fixtures/common_functional_init'))()

  casper.start(urls.home, ->
    test.assertHttpStatus(200, 'Page is loaded.')
  
  ).waitUntilVisible('#search-form').then( ->
    test.assertVisible('#search-form', 'The form is visible.')
    this.click('#submitter')
  
  ).waitUntilVisible('#validation-error-message').then( ->
    test.assertVisible('#validation-error-message',
      'The validation message shows when fields are empty')
    this.fill('form', fixtures.search, false)
    this.click('#submitter')

  ).waitUntilVisible('div#releases').then( ->
    test.assertEval(( -> $('div#releases li').length > 0), 'It loads albums.')
    test.assertEvalEquals(( -> $('svg').length),
      fixtures.chartsCount, 'All the charts (svg) are rendered.')
    this.click('div#releases li .release-link')
    
  ).waitUntilVisible('.singleRelease').then( ->
    test.assertVisible('.singleRelease', 'The single release is visible.')
    test.assertEval(( -> $('.singleRelease').html().trim() != ''),
      'The single release is not empty.')
    this.click('.back')
  
  ).waitUntilVisible('div#releases').then( ->
    test.assertVisible('div#releases', 'When click back, it shows the list again.')
    test.assertEval(( -> $('div#releases li').length > 0), 'It loads albums in list again.')
    this.click('.back')

  ).waitUntilVisible('#search-form').then( ->
    test.assertVisible('#search-form', 'The form is visible again when click back.')
    test.assertEvalEquals(( -> $('input[name="band"]').val()),
      fixtures.search.band, 'The field album still has the value.')

  )
  
  casper.run( -> test.done() )
)