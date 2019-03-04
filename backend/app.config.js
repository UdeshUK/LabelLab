var config = {};

config.BUCKET_PATH = "/labellab";
config.TEMP_FILE_PATH = config.BUCKET_PATH + "/temp";

// Version
config.VERSION = "/v1"

// Database configuration
const db = {
  host: process.env.DB_HOST,
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  dbName: process.env.DB_NAME
}
console.log(db);
config.DB = 'mongodb+srv://' + db.username + ':' + db.password + '@' + db.dbName + '-' + db.host + '/test?retryWrites=true'

// Secrets
config.SECRET = process.env.SECRET;

module.exports = config;