const db = require("../../dbconfig"); 
const Product = require("../models/productModel");
const multer = require("multer");
const path = require("path");

// ตั้งค่า multer สำหรับเก็บไฟล์ใน uploads/
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    const filename = Date.now() + ext;
    cb(null, filename);
  },
});
const upload = multer({ storage });

// Export multer upload middleware
exports.upload = upload;

// ฟังก์ชันสร้างสินค้า พร้อมอัปโหลดรูป
exports.uploadWithPhoto = (req, res) => {
  const { pro_name, pro_price, pro_qty, user_id } = req.body;
  const photo = req.file ? req.file.filename : null;

  if (!pro_name || !pro_price || !user_id) {
    return res.status(400).json({ error: "pro_name, pro_price, and user_id are required" });
  }

  const sql = "INSERT INTO product (pro_name, pro_price, pro_qty, user_id, photo) VALUES (?, ?, ?, ?, ?)";
  db.query(sql, [pro_name, pro_price, pro_qty || 0, user_id, photo], (err, result) => {
    if (err) {
      console.error("Insert product error:", err);
      return res.status(500).json({ error: "Database insert error", details: err.message });
    }
    res.json({
      message: "Product created with image",
      id: result.insertId,
      pro_name,
      pro_price,
      pro_qty,
      user_id,
      photo,
    });
  });
};

// ฟังก์ชันอัปเดตสินค้า พร้อมอัปโหลดรูป (ถ้ามี)
exports.updateWithPhoto = (req, res) => {
   console.log("req.body:", req.body);
  console.log("req.file:", req.file);
  const { pro_name, pro_price, pro_qty, user_id } = req.body;
  const photo = req.file ? req.file.filename : null;
  const productId = req.params.id;

  if (!productId) {
    return res.status(400).json({ error: "Product ID is required" });
  }

  if (!pro_name || !pro_price || !user_id) {
    return res.status(400).json({ error: "pro_name, pro_price, and user_id are required" });
  }

  let sql, params;
  if (photo) {
    sql = "UPDATE product SET pro_name=?, pro_price=?, pro_qty=?, user_id=?, photo=? WHERE pro_id=?";
    params = [pro_name, pro_price, pro_qty || 0, user_id, photo, productId];
  } else {
    sql = "UPDATE product SET pro_name=?, pro_price=?, pro_qty=?, user_id=? WHERE pro_id=?";
    params = [pro_name, pro_price, pro_qty || 0, user_id, productId];
  }

  db.query(sql, params, (err, result) => {
    if (err) {
      console.error("Update product error:", err);
      return res.status(500).json({ error: "Database update error", details: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Product not found" });
    }
    res.json({ message: "Product updated", productId, photo });
  });
};

// ฟังก์ชันอื่น ๆ ของคุณ (getAll, getById, create, update, delete, getMyProducts) ...
exports.getAll = (req, res) => {
  Product.getAllProducts((err, result) => {
    if (err) {
      console.error("Get all products error:", err);
      return res.status(500).json({ error: "Failed to get products", details: err.message });
    }
    res.json(result);
  });
};

exports.getById = (req, res) => {
  const id = req.params.id;
  if (!id) {
    return res.status(400).json({ error: "Product ID is required" });
  }
  Product.getProductById(id, (err, result) => {
    if (err) {
      console.error("Get product by ID error:", err);
      return res.status(500).json({ error: "Failed to get product", details: err.message });
    }
    if (!result[0]) {
      return res.status(404).json({ error: "Product not found" });
    }
    res.json(result[0]);
  });
};

exports.create = (req, res) => {
  if (!req.body.pro_name || !req.body.pro_price || !req.body.user_id) {
    return res.status(400).json({ error: "pro_name, pro_price, and user_id are required" });
  }
  Product.createProduct(req.body, (err, result) => {
    if (err) {
      console.error("Create product error:", err);
      return res.status(500).json({ error: "Failed to create product", details: err.message });
    }
    res.json({ message: "Product created", id: result.insertId });
  });
};

exports.update = (req, res) => {
  const id = req.params.id;
  if (!id) {
    return res.status(400).json({ error: "Product ID is required" });
  }
  Product.updateProduct(id, req.body, (err, result) => {
    if (err) {
      console.error("Update product error:", err);
      return res.status(500).json({ error: "Failed to update product", details: err.message });
    }
    res.json({ message: "Product updated" });
  });
};

exports.delete = (req, res) => {
  const id = req.params.id;
  if (!id) {
    return res.status(400).json({ error: "Product ID is required" });
  }
  Product.deleteProduct(id, (err, result) => {
    if (err) {
      console.error("Delete product error:", err);
      return res.status(500).json({ error: "Failed to delete product", details: err.message });
    }
    res.json({ message: "Product deleted" });
  });
};

exports.getMyProducts = (req, res) => {
  const userId = req.query.user_id;
  if (!userId) {
    return res.status(400).json({ message: "user_id is required" });
  }
  db.query("SELECT * FROM product WHERE user_id = ?", [userId], (err, result) => {
    if (err) {
      console.error("Get my products error:", err);
      return res.status(500).json({ error: "Failed to get user's products", details: err.message });
    }
    res.json(result);
  });
};

exports.getMyProductsByUser = (req, res) => {
  const userId = req.params.userId;
  Product.getProductsByUserId(userId, (err, results) => {
    if (err) {
      console.error("Get products by user error:", err);
      return res.status(500).json({ message: "Server error", details: err.message });
    }
    res.json(results);
  });
};
