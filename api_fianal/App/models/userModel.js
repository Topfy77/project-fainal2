const db = require("../../dbconfig");

exports.getAllUsers = (callback) => {
  db.query("SELECT * FROM user", callback);
};

exports.getUserById = (id, callback) => {
  db.query("SELECT * FROM user WHERE user_id = ?", [id], callback);
};

exports.createUser = (data, callback) => {
  db.query("INSERT INTO user SET ?", data, callback);
};

exports.updateUser = (id, data, callback) => {
  db.query("UPDATE user SET ? WHERE user_id = ?", [data, id], callback);
};

exports.deleteUser = (id, callback) => {
  db.query("DELETE FROM user WHERE user_id = ?", [id], callback);
};

exports.getUserByEmail = (Email, callback) => {
  db.query("SELECT * FROM user WHERE email = ?", [Email], callback);
};




