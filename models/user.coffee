db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class User extends ActiveRecord

  constructor: (attributes) ->
    super(attributes)

  @attributes_structure: () ->
    email: 'string'
    password: 'string'
    password_confirmation: 'string'

  @all: (ctrlClb) ->
    db.all('user', (results) ->
      # format data
      users = _.map(results, (value) ->
        new User(value.value)
      )

      # inject data into the controller
      ctrlClb(users)
    )

module.exports = User
