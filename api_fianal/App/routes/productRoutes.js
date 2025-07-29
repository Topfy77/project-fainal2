const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");

// multer middleware สำหรับอัปโหลดไฟล์ (ต้องเรียกใช้ .single() ด้วย)
const upload = productController.upload.single("photo");

// routes
router.get("/my-products", productController.getMyProducts);
router.get("/", productController.getAll);
router.get("/:id", productController.getById);

// สร้างสินค้า พร้อมอัปโหลดรูป
router.post("/", upload, productController.uploadWithPhoto);

// อัปเดตสินค้า พร้อมอัปโหลดรูป (ถ้ามี)
router.put("/:id", upload, productController.updateWithPhoto);

router.delete("/:id", productController.delete);

module.exports = router;
