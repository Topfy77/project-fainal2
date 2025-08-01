// src/App.js
import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import HomePage from "./pages/HomePage";
import MyProductsPage from "./pages/MyProductsPage";
import RegisterPage from "./pages/Register";
import DetailPage from "./pages/DetailPage";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/home" element={<HomePage />} />            
        <Route path="/my-products" element={<MyProductsPage />} /> 
       <Route path="/register" element={<RegisterPage />} />
       <Route path="/register" element={<RegisterPage />} />
       <Route path="/detail" element={< DetailPage/>} />
      </Routes>
    </Router>
  );
};

export default App;
