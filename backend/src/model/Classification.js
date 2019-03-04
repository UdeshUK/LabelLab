const mongoose = require('mongoose')

const classificationSchema = mongoose.Schema({
  path: String,
  size: String,
  classifiedBy: String,
  timestamp: Date
})

module.exports = mongoose.model('Classification', classificationSchema)
