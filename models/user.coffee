db = require('../db')

class User
  constructor: ->

  @all: (func) ->
    db.all('user', 'email', func)

module.exports = User
