const db = require("../../dbconfig");

exports.getAllProducts = (callback) => {
  db.query("SELECT * FROM product", callback);
};

exports.getProductById = (id, callback) => {
  db.query("SELECT * FROM product WHERE pro_id = ?", [id], callback);
};

exports.createProduct = (data, callback) => {
  db.query("INSERT INTO product SET ?", data, callback);
};

exports.updateProduct = (id, data, callback) => {
  db.query("UPDATE product SET ? WHERE pro_id = ?", [data, id], callback);
};

exports.deleteProduct = (id, callback) => {
  db.query("DELETE FROM product WHERE pro_id = ?", [id], callback);
};
