const express = require('express')
const router = express.Router()
const uuid = require('uuid')
const mv = require('mv')
const verify = require("../auth/verify")
const Classification = require('../model/Classification')

router.get('/', function (req, res, next) {
  res.send({
    title: 'labellab',
    route: '/classify',
    description: 'Classification API',
    endpoints: [
      { route: '/image', description: 'Label a given image usign classification model.' }
    ]
  })
})

router.get('/history', [verify.decodeToken], function (req, res, next) {
  Classification.find({ classifiedBy: req.uid }).then(classifications => {
    console.log(classifications);
    res.status(200).send(classifications);
  }).catch(err => {
    return res.status(500).send({ message: 'No classifications found.' });
  });
})

router.post('/image', [verify.decodeToken], function (req, res) {
  if (!!req.files) {
    if (Object.keys(req.files).length === 0)
      return res.status(400).send({ message: 'No files were uploaded.' })

    if (req.files.image) {
      let uuidKey = uuid();
      let staticPath = __dirname + '/../../classifications/';
      let publicLocation = 'images/' + uuidKey;
      let newLocation = staticPath + publicLocation;

      var image = req.files.image

      mv(image.tempFilePath, newLocation, function (err) {
        if (err)
          return res.status(500).send(err);

        const classification = new Classification({
          path: uuidKey,
          size: image.data.length,
          classifiedBy: req.uid,
          timestamp: Date.now()
        });

        classification.save().then(newClassification => {
          return res.status(200).send(newClassification)
        }).catch(err => {
          console.log(err);
          return res.status(500).send({ message: 'Image classification error.' });
        });
      });
    } else {
      return res.status(400).send({ message: 'Bad request, doesn\'t contain image.' })
    }
  } else {
    return res.status(400).send({ message: 'Bad request.' })
  }
})

module.exports = router
