db = require('../db')
_ = require('underscore')
ActiveRecord = require('./active_record.coffee')

class Match extends ActiveRecord

  constructor: (attributes, validate = true) ->
    super(attributes, validate)

  @attributes_structure:
    fields: ['id', 'first', 'second']
    validates:
      id: 'string'
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
    match = new User(doc)
    db.create('match', match, func )

module.exports = Match
