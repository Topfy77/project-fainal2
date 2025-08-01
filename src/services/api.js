// src/services/api.js
import axios from "axios";

const API = axios.create({
  baseURL: "http://localhost:3000/api", // ตรวจสอบว่า backend URL ถูกต้อง
});

// ✅ LOGIN
export const login = (email, password) => {
  return API.post("/users/login", { email, password });
};

// ✅ GET: สินค้าทั้งหมด (ถ้ามีหน้า Home หรือทั้งหมด)
export const getAllProducts = () => {
  return API.get("/products");
};

// ✅ GET: สินค้าของผู้ใช้คนนั้น
export const getMyProducts = (userId) => {
  return API.get(`/products/my-products?user_id=${userId}`);
};

// ✅ POST: สร้างสินค้าใหม่
export const createProduct = (data) => {
  return API.post("/products", data);
};

// ✅ PUT: แก้ไขสินค้า
export const updateProduct = (id, data) => {
  return API.put(`/products/${id}`, data);
};

// ✅ DELETE: ลบสินค้า
export const deleteProduct = (id) => {
  return API.delete(`/products/${id}`);
};
