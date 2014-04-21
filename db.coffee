cb = require('couchbase')
_ = require('underscore')
Q = require('q')

config =
  host : [ "localhost:8091" ]
  bucket : 'remember'

db = new cb.Connection( config )

exports.all = (view, modelClb) ->
  deferred = Q.defer()
  db.view( "#{view}s", "#{view}s").query (err, results) ->
    deferred.reject(err) if err

    indexes = _.map(results, (obj) ->
      obj.id
    )

    db.getMulti(indexes, {}, (err, results2) ->
      throw err if err

      #TODO reduce looping. i'm looping through the element also in the model to create the object
      results2 = _.map(results2, (item) ->
        item.value
      )

      deferred.resolve(results2)
    )

  deferred.promise.nodeify(modelClb)

exports.find = (key, modelClb) ->
  db.get(key, (err, result) ->
    throw err if err

    doc = result.value
    modelClb(doc)
  )

###
  * Function to create a new object in the database
  * @param {doctype} model name as string
  * @param {doc} model
  * @param {modelClb} model callback
###
exports.create = (doctype, doc, modelClb) ->
  doctype = doctype.toLowerCase()

  db.incr("#{doctype}::count", (err, result) ->
    new_id = "#{doctype}::#{result.value}"

    # add id and doctype to the document
    doc.id = new_id
    doc.doctype = doctype

    # add operation returns an error it the id already exists
    db.add(new_id, doc, (err, result) ->
      throw err if err

      db.get(new_id, (err, result) ->
        throw err if err

        doc = result.value
        modelClb(doc)
      )
    )
  )