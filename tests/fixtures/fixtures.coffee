module.exports = {
  urls: ((unit = false)->
    u = {base: 'http://localhost:4000'}
    u.home = u.base + '/'

    return u
  )()
}