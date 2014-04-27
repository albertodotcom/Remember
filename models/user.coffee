db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class User extends ActiveRecord

  constructor: (attributes, validate = true) ->
    super(attributes, validate)

  @attributes_structure:
    fields: ['id', 'email', 'password', 'password_confirmation']
   
    validates:
      id:
        type: 'string'
        error: 'It must be string'

      email:
        regex:
          value: /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/
          error: "Your email address isn't correct"

      password:
        type: 'string'
        length:
          min: 8
          error: "Password must be at least 8 characters"

      password_confirmation:
        equalTo: 'password'

module.exports = User
