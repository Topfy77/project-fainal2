const Product = require("../models/productModel");

exports.getAll = (req, res) => {
  Product.getAllProducts((err, result) => {
    if (err) res.status(500).send(err);
    else res.json(result);
  });
};

exports.getById = (req, res) => {
  Product.getProductById(req.params.id, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json(result[0]);
  });
};

exports.create = (req, res) => {
  Product.createProduct(req.body, (err, result) => {
    console.log(req.body)
    if (err) res.status(500).send(err);
    else res.json({ message: "Product created", id: result.insertId });
  });
};

exports.update = (req, res) => {
  Product.updateProduct(req.params.id, req.body, (err, result) => {
    console.log(req.body)
     console.log(err)
    if (err) res.status(500).send(err);
    else res.json({ message: "Product updated" });
   
  });
};

exports.delete = (req, res) => {
  Product.deleteProduct(req.params.id, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json({ message: "Product deleted" });
  });
};
