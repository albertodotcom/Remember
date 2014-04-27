express = require("express")
router = express.Router()
Match = require('../models/match')

# TODO validate accepted params

router.get '/new', (req, res) ->
  res.render('new', {})

router.get "/", (req, res) ->
  Match.all (matches) ->
    res.json(matches)

router.post '/', (req, res) ->
  Match.create(req.body, (match) ->
    res.status(201).json(match)
  )

router.get '/:match', (req, res) ->
  match = req.param('match')
  return res.status(404) unless match

  Match.find( match, (doc) ->
    return res.status(404).json({status: 'not found'}) unless doc

    res.json(doc)
  )

module.exports = router