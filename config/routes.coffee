module.exports.routes = {
  '/': 'DiggerController.show',
  '/releases/': 'DiggerController.releasesList',
  '/release/:id': 'DiggerController.release',
  '/search': 'DiggerController.search'
  '/album': 'DiggerController.album'
}