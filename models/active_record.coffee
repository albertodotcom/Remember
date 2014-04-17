db = require('../db')
_ = require('underscore')

class ActiveRecord
  constructor: (attributes) ->
    attributes_structure = @constructor.attributes_structure()
    _.each(attributes, (value, key) ->
      if attributes_structure[key]?
        @[key] = value
    , this )

    return this

  @all: (className, func) ->
    db.all(className, func)

  @find: (key, ctrlClb) ->
    db.find(key, ctrlClb)

module.exports = ActiveRecord