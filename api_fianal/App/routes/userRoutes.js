const express = require("express");
const router = express.Router();
const user = require("../controllers/userController");

// ✅ เพิ่มบรรทัดนี้เข้าไปด้านบน
router.post("/register", user.create); // ✅ <- สำคัญที่สุด

// ที่เหลือคงเดิม
router.post("/login", user.login);
router.get("/", user.getAll);
router.get("/:id", user.getById);
 // << ไม่จำเป็นถ้าใช้ /register
router.put("/:id", user.update);
router.delete("/:id", user.delete);

module.exports = router;
