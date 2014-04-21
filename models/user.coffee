db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')
Q = require('q')

class User extends ActiveRecord

  constructor: (attributes, validate = true) ->
    super(attributes, validate)

  @attributes_structure:
    fields: ['id', 'email', 'password', 'password_confirmation']
#    actions:
#      save: 'all',
#      read:
#        except: ['password', 'password_confirmation']

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

  @all: (ctrlClb) ->
#    db.all('user', (err, results) ->
#      # format data
#      users = _.map(results, (value) ->
#        new User(value, false)
#      )
#
#      # inject data into the controller
#      ctrlClb(users)
#    )
#
    users = db.all('user')
    users.then(
      (results) ->
        # format data
        users = _.map(results, (value) ->
          new User(value, false)
        )

        # inject data into the controller
        ctrlClb(users)
    ).done()

  @create: (doc, ctrlClb) ->
    user = new User(doc)
    db.create('user', user, ctrlClb )

module.exports = User
