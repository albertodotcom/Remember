db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class User extends ActiveRecord

  @all: (ctrlClb) ->
    db.all('user', 'user', (results) ->
      # format data
      users = _.map(results, (v, k) ->
        id: v.id
        email: v.key
      )

      # inject data into the controller
      ctrlClb(users)
    )

module.exports = User
