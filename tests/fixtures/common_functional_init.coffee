module.exports = (()->
  casper.on('remote.message', (msg)-> casper.echo('* Remote error: ' + msg, 'WARNING'); )
  casper.on('remote.error', (msg)-> casper.echo('* Remote error: ' + msg, 'WARNING'); )
  casper.on('resource.error', (err)-> casper.echo('* Remote error: ' +
    err.errorString , 'WARNING') )

  global.fixtures = require('../fixtures/fixtures')
  global.urls = fixtures.urls

  global.Faker = require('/usr/lib/node_modules/faker/')
)