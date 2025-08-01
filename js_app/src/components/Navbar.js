// src/components/Navbar.js
import React, { useState, useEffect } from "react";
import {
  Drawer,
  Box,
  Button,
  Typography,
  IconButton,
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import CloseIcon from "@mui/icons-material/Close";

const Navbar = ({ open, onClose }) => {
  const navigate = useNavigate();
  const [username, setUsername] = useState("");

  useEffect(() => {
    const storedUsername = localStorage.getItem("username");
    if (storedUsername) {
      setUsername(storedUsername);
    }
  }, []);

  return (
    <Drawer anchor="left" open={open} onClose={onClose}>
      <Box
        sx={{
          width: 200,
          bgcolor: "primary.main",
          height: "100%",
          color: "white",
          display: "flex",
          flexDirection: "column",
          p: 2,
          gap: 2,
        }}
      >
        

        {/* 👇 แสดงชื่อผู้ใช้ */}
        <Typography variant="body1" sx={{ mt: 1 }}>
          {username && `Welcome , ${username}`}
        </Typography>
        <Box sx={{ display: "flex", justifyContent: "space-between" }}>
          <Typography variant="h6">Menu</Typography>
          <IconButton onClick={onClose} sx={{ color: "white" }}>
            <CloseIcon />
          </IconButton>
        </Box>

        <Button variant="contained" color="info" onClick={() => navigate("/home")}>
          Home
        </Button>
        <Button variant="contained" color="info" onClick={() => navigate("/my-products")}>
          My Products
        </Button>
        <Button
          variant="contained"
          color="info"
          onClick={() => {
            localStorage.clear(); // ลบ token/user เมื่อ logout
            navigate("/");
          }}
        >
          Logout
        </Button>
      </Box>
    </Drawer>
  );
};

export default Navbar;
