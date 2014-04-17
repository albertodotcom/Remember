db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class Match extends ActiveRecord

  constructor: (attributes) ->
    super(attributes)

  @attributes_structure: () ->
    id: 'number'
    first: 'string'
    second: 'string'

  @all: (ctrlClb) ->
    db.all('match', (results) ->
      # format data
      matches = _.map(results, (value) ->
        new Match(value)
      )

      # inject data into the controller
      ctrlClb(matches)
    )

  @create: (doc, func) ->
    id = doc.first[0..3].replace(' ', '_')
    db.create( id, doc, func )

module.exports = Match
