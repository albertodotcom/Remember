cb = require('couchbase')
_ = require('underscore')

config =
  host : [ "localhost:8091" ]
  bucket : 'remember'

db = new cb.Connection( config )

exports.all = (view, modelClb) ->
  db.view( "#{view}s", "#{view}s").query (err, results) ->
    throw err if err

    indexes = _.map(results, (obj) ->
      obj.id
    )

    db.getMulti(indexes, {}, (err, results2) ->
      throw err if err

      #TODO reduce looping. i'm looping through the element also in the model to create the object
      results2 = _.map(results2, (item) ->
        item.value
      )

      modelClb(results2)
    )

exports.find = (key, modelClb) ->
  db.get(key, (err, result) ->
    throw err if err

    doc = result.value
    modelClb(doc)
  )

exports.create = (id, doc, modelClb) ->
  db.add(id, doc, (err, result) ->
    throw err if err

    db.get(id, (err, result) ->
      throw err if err

      doc = result.value
      modelClb(doc)
    )
  )