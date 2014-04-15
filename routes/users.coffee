express = require("express")
router = express.Router()
User = require('../models/user')

# GET users listing. 
router.get "/", (req, res) ->
  User.all (users) ->
    res.json(users)

module.exports = router
