db = require('../db')
_ = require('underscore')

class ActiveRecord
  constructor: (attributes, validate = true) ->
    attributes_structure = @constructor.attributes_structure.fields

    @errors = {}

    _.each(attributes, (value, key) ->
      if _.include(attributes_structure, key)
        @[key] = value

        # validations
        return unless validate
        fieldValidation = @_validate(key)

        if not fieldValidation.isValid
          @errors[key] = @errors[key] || []
          @errors[key].push(fieldValidation.error) unless fieldValidation.isValid

    , this)

    return this

  @attributes_structure:
    fields: []
    actions: {}
    validates: {}

  _validate: (field) ->
    validations = @constructor.attributes_structure.validates[field]

    return {isValid: true} unless validations?

    if validations.type?
      switch validations.type
        when 'string'
          return {isValid: false, error: validations.error || "#{field} must be a string"} unless _.isString(@[field])

    {isValid: true}


  @all: (className, func) ->
    db.all(className, func)

  @find: (key, ctrlClb) ->
    db.find(key, ctrlClb)

module.exports = ActiveRecord