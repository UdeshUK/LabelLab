const User = require('../model/User')
const config = require('../../app.config')
const jwt = require('jsonwebtoken')

// Username & email check handler
const checkDuplicateUserNameOrEmail = (req, res, next) => {
  User.findOne({ username: req.body.username })
    .exec((err, user) => {
      console.log(user)
      if (err && err.kind !== 'ObjectId') {
        res.status(500).send({
          message: 'Error retrieving User with Username = ' + req.body.username
        })
        return
      }

      if (user) {
        res.status(400).send({ message: 'Username is already in taken!' })
        return
      }

      User.findOne({ email: req.body.email })
        .exec((err, user) => {
          if (err && err.kind !== 'ObjectId') {
            res.status(500).send({
              message: 'Error retrieving User with Email = ' + req.body.email
            })
            return
          }

          if (user) {
            res.status(400).send({ message: 'Email is already in use!' })
            return
          }

          next()
        })
    })
}

// JWT verify handler
const decodeToken = (req, res, next) => {
  let token = req.headers['x-access-token']

  if (!token) {
    return res.status(403).send({
      auth: false, message: 'No token provided.'
    })
  }

  jwt.verify(token, config.SECRET, (err, decoded) => {
    if (err) {
      return res.status(500).send({
        auth: false,
        message: 'Fail to Authentication. Error -> ' + err
      })
    }
    req.uid = decoded.id
    if (!req.uid) {
      return res.status(401).send({ message: 'Invalid user.' })
    }
    next()
  })
}

const verify = {}
verify.checkDuplicateUserNameOrEmail = checkDuplicateUserNameOrEmail
verify.decodeToken = decodeToken
module.exports = verify
