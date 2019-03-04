const mongoose = require('mongoose'), Schema = mongoose.Schema;
 
const userSchema = mongoose.Schema({
 name: String,
 username: String,
 email: String,
 password: String,
});
 
module.exports = mongoose.model('User', userSchema);