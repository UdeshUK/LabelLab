var express = require('express')
var router = express.Router()

router.get('/', function (req, res, next) {
  res.send({
    title: 'labellab',
    routes: [
      { route: '/classify', description: 'Classification API' }
    ]
  })
})

module.exports = router
