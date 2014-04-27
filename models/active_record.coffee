db = require('../db')
_ = require('underscore')
Q = require('q')

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

  @attributes_structure:
    fields: []
    hideFields: []
    validates: {}

  _validate: (field) ->
    validations = @constructor.attributes_structure.validates[field]

    return {isValid: true} unless validations?

    if validations.type?
      switch validations.type
        when 'string'
          return {isValid: false, error: validations.error || "#{field} must be a string"} unless _.isString(@[field])

    {isValid: true}

  attributes: (params = {}, hideFields = []) ->
    
    attributes = params.attributes || @constructor.attributes_structure.fields
    except = params.hideFields || @constructor.attributes_structure.hideFields

    model = {}

    _.each(attributes,
      (attr) ->
        return if _.include(except, attr)
        model[attr] = @[attr]
    , this)

    model

  @create: (params) ->
    deferred = Q.defer()
    
    self = this
    modelName = @name.toLowerCase()

    model = new self.prototype.constructor(params)

    resultPromise = db.create modelName, model.attributes()

    resultPromise
      .then (result) ->

        # update user
        model.id = result.id

        deferred.resolve(model.attributes())

      .catch (err) ->
        deferred.reject new Error(err)

      .done()

    deferred.promise
  
  ###*
   * Static method - find all the elements
   * @return {promise} models promise
  ###
  @all: () ->
    deferred = Q.defer()

    modelName = @name.toLowerCase()

    resultsPromise = db.all(modelName)

    self = this
    resultsPromise
      .then (results) ->
        # format data
        models = _.map(results, (value) ->
          new self.prototype.constructor(value, false).attributes()
        )

        deferred.resolve(models)

      .catch (err) ->
        deferred.reject(new Error(error))

      .done()

    deferred.promise

  ###*
   * Static method - find an element
   * @param  {string}   key   object identifier
   * @return {promise}  model promise
  ###
  @find: (key) ->
    deferred = Q.defer()

    modelName = @name.toLowerCase()

    resultPromise = db.find(key, modelName)

    self = this
    resultPromise
      .then (dbObj) ->
        modelInstance = new self.prototype.constructor(dbObj).attributes()
        deferred.resolve(modelInstance)

      .catch (err) ->
        deferred.reject(err)

      .done()

    deferred.promise

module.exports = ActiveRecord