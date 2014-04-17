express = require("express")
router = express.Router()
User = require('../models/user')

# GET users listing. 
router.get "/", (req, res) ->
  User.all (users) ->
    res.json(users)

router.get "/:email", (req, res) ->
  res.status(404).json() unless req.param('email')

  User.find req.param('email'), (user) ->
    res.status(404).json({status: 'not found'}) unless user

    res.json(user)

router.post "/", (req, res) ->
  userParams = req.param('user')
  res.status(404).json() unless userParams

  User.create userParams, (user) ->
    res.status(404).json({status: 'not found'}) unless user

    user = new User(user)

    res.json(user)

module.exports = router
