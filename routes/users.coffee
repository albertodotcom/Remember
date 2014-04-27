express = require("express")
_ = require('underscore')
router = express.Router()
User = require('../models/user')

###*
 * Get all the users
###
router.get "/", (req, res) ->

  users = User.all()
  
  users
    .then (users) ->
      res.json(users)

    .catch (err) ->
      console.log(err)
      res.status(500).json()

    .done()
    

###*
 * Get a user
###
router.get "/:id", (req, res) ->
  isParamsOk = req.param('id') && not _.isNaN parseInt(req.param('id'))
  return res.status(404).json() unless isParamsOk

  userPromise = User.find req.param('id')
  userPromise
    .then (user) ->
      res.json(user)

    .catch (err) ->
      console.log(err)
      res.status(404).json({status: 'not found'})

    .done()

    

###*
 * Create a new user
 * @return {object} created user
###
router.post "/", (req, res) ->
  userParams = req.param('user')
  return res.status(404).json() unless userParams
  
  user = User.create(userParams)

  user
    .then (user) ->
      res.json(user)

    .catch (err) ->
      console.log(err)
      res.status(500).json()

    .done()


module.exports = router
