const mongoose = require('mongoose')

const classificationSchema = mongoose.Schema({
  path: String,
  width: Number,
  height: Number,
  type: String,
  classifiedBy: String,
  timestamp: Date
})

module.exports = mongoose.model('Classification', classificationSchema)
