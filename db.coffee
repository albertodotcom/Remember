cb = require('couchbase')

config =
  host : [ "localhost:8091" ]
  bucket : 'remember'

db = new cb.Connection( config )

exports.all = (view, fields, modelClb) ->
  db.view( "#{view}s", "#{fields}s").query (err, results) ->
    throw err if err

    modelClb(results)

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