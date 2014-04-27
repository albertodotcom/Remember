cb = require('couchbase')
_ = require('underscore')
Q = require('q')

config =
  host : [ "localhost:8091" ]
  bucket : 'remember'

db = new cb.Connection( config )

exports.all = (view) ->
  deferred = Q.defer()

  db.view( "#{view}", "#{view}_all").query (err, ids) ->
    deferred.reject new Error(err) if err

    indexes = _.map ids, (obj) ->
      obj.id

    db.getMulti indexes, {}, (err, documents) ->
      deferred.reject new Error(err) if err

      #TODO reduce looping. i'm looping through the element also in the model to create the object
      documents = _.map(documents, (item) ->
        item.value
      )

      deferred.resolve(documents)

  deferred.promise

###*
 * find an element in the database
 * @param  {string}   key   the key of the object in the database
 * @return {promise}  element
###
exports.find = (key, doctype) ->
  deferred = Q.defer()

  db.get "#{doctype}::#{key}", (err, result) ->
    # TODO handle not found
    deferred.reject new Error(err) if err

    deferred.resolve result.value

  deferred.promise

###*
 * create a new instance in the database
 * @param  {string}   doctype     table name
 * @param  {object}   doc         object defined in the model
 * @param  {function} modelClb    callback of the model
 * @return {promise}  created object
###
exports.create = (doctype, doc) ->
  deferred = Q.defer()

  doctype = doctype.toLowerCase()

  db.incr "#{doctype}::count", (err, result) ->
    deferred.reject new Error(err) if err

    new_id = "#{doctype}::#{result.value}"

    # add id and doctype to the document
    doc.id = new_id
    doc.doctype = doctype

    # add operation returns an error it the id already exists
    db.add new_id, doc, (err, result) ->
      deferred.reject new Error(err) if err

      db.get new_id, (err, result) ->
        deferred.reject new Error(err) if err

        deferred.resolve(result.value)

  deferred.promise