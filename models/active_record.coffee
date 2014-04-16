db = require('../db')
_ = require('underscore')

class ActiveRecord
  constructor: ->

  @all: (className, func) ->
    db.all(className, className, func)

  @find: (key, ctrlClb) ->
    db.find(key, ctrlClb)

module.exports = ActiveRecord