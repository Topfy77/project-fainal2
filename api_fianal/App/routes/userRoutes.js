
const express = require("express");
const router = express.Router();
const user = require("../controllers/userController");

// ✅ ตรวจให้ชัวร์ว่า user.login เป็นฟังก์ชัน
router.post("/login", user.login);
router.get("/", user.getAll);
router.get("/:id", user.getById);
router.post("/", user.create);
router.put("/:id", user.update);
router.delete("/:id", user.delete);

module.exports = router;
