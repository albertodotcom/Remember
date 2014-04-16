db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class Match extends ActiveRecord

  @all: (ctrlClb) ->
    db.all('match', 'match', (results) ->
      # format data
#      matches = _.map(results, (v, k) ->
#        id: v.id
#        email: v.key
#      )

      # inject data into the controller
      ctrlClb(results)
    )

  @create: (doc, func) ->
    id = doc.first[0..3].replace(' ', '_')
    db.create( id, doc, func )

module.exports = Match
