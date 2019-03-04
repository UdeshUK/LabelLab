const mongoose = require('mongoose'), Schema = mongoose.Schema;

const classificationSchema = mongoose.Schema({
  path: String,
  size: String,
  classifiedBy: String,
  timestamp: Date
});

module.exports = mongoose.model('Classification', classificationSchema);