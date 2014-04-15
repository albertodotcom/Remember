cb = require('couchbase')
_ = require('underscore')

config =
  host : [ "localhost:8091" ]
  bucket : 'remember'

db = new cb.Connection( config )

exports.all = (view, fields, func) ->
  db.view( "#{view}s", "by_#{fields}").query (err, results) ->
    users = _.map(results, (v, k) ->
      id: v.id
      email: v.key
    )
    func(users)