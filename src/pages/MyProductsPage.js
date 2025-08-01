// src/pages/MyProductsPage.js
import React, { useEffect, useState } from "react";
import {
  Container,
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  IconButton,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  CardActions,
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import {
  getMyProducts,
  deleteProduct,
  updateProduct,
  createProduct,
} from "../services/api";
import Navbar from "../components/Navbar";

const MyProductsPage = () => {
  const [productList, setProductList] = useState([]); // เปลี่ยนชื่อ state เป็น productList เพื่อความชัดเจน
  const [menuOpen, setMenuOpen] = useState(false);
  const [openDialog, setOpenDialog] = useState(false);
  const [editingProduct, setEditingProduct] = useState(null);

  // form state
  const [form, setForm] = useState({ pro_name: "", pro_price: "", photo: null });

  useEffect(() => {
    fetchProductList();
  }, []);

  const fetchProductList = () => {
    const userId = localStorage.getItem("user_id");
    if (userId) {
      getMyProducts(userId)
        .then((res) => {
          const data = Array.isArray(res.data) ? res.data : res.data.product || [];
          setProductList(data);
        })
        .catch((error) => {
          console.error("❌ Failed to fetch product:", error);
          setProductList([]);
        });
    } else {
      console.warn("⚠️ No userId found in localStorage.");
    }
  };

  const handleAdd = () => {
    setEditingProduct(null);
    setForm({ pro_name: "", pro_price: "", photo: null });
    setOpenDialog(true);
  };

  const handleEdit = (product) => {
    setEditingProduct(product);
    setForm({
      pro_name: product.pro_name,
      pro_price: product.pro_price,
      photo: null,
    });
    setOpenDialog(true);
  };

  const handleDelete = async (id) => {
    try {
      await deleteProduct(id);
      setProductList(productList.filter((p) => p.pro_id !== id));
    } catch (err) {
      console.error("❌ Delete failed", err);
    }
  };

  const handleSubmit = async () => {
    const user_id = localStorage.getItem("user_id");

    try {
      const formData = new FormData();
      formData.append("pro_name", form.pro_name);
      formData.append("pro_price", form.pro_price);
      formData.append("user_id", user_id);
      if (form.photo) {
        formData.append("photo", form.photo);
      }

      let res;
      if (editingProduct) {
        res = await updateProduct(editingProduct.pro_id, formData);
        setProductList(
          productList.map((p) =>
            p.pro_id === editingProduct.pro_id
              ? { ...p, ...form, photo: res.data.photo || p.photo }
              : p
          )
        );
      } else {
        res = await createProduct(formData);
        setProductList([...productList, res.data]);
      }
      setOpenDialog(false);
    } catch (err) {
      console.error("❌ Submit failed", err);
    }
  };

  return (
    <Box>
      {/* Header */}
      <Box sx={{ display: "flex", alignItems: "center", p: 2 }}>
        <IconButton onClick={() => setMenuOpen(true)}>
          <MenuIcon />
        </IconButton>
        <Typography variant="h4" sx={{ ml: 2 }}>
          My Product
        </Typography>
      </Box>

      <Navbar open={menuOpen} onClose={() => setMenuOpen(false)} />

      <Box sx={{ textAlign: "right", mx: 3 }}>
        <Button variant="contained" onClick={handleAdd}>
          Add Product
        </Button>
      </Box>

      <Container sx={{ mt: 2 }}>
        <Grid container spacing={2}>
          {productList.length === 0 && <Typography>No product found.</Typography>}
          {productList.map((p) => (
            <Grid key={p.pro_id} item xs={12} sm={6} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Name: {p.pro_name}</Typography>
                  <Typography color="text.secondary">Price: {p.pro_price}</Typography>
                  {p.photo && (
                    <img
                      src={`http://localhost:3000/uploads/${p.photo}`}
                      alt={p.pro_name}
                      style={{ width: "70%", marginTop: 10 }}
                    />
                  )}
                </CardContent>
                <CardActions>
                  <Button variant="contained" onClick={() => handleEdit(p)}>Edit</Button>
                  <Button variant="contained" color="error" onClick={() => handleDelete(p.pro_id)}>
                    Delete
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>

      {/* Dialog Add/Edit */}
      <Dialog open={openDialog} onClose={() => setOpenDialog(false)}>
        <DialogTitle>{editingProduct ? "Edit Product" : "Add Product"}</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Product Name"
            fullWidth
            value={form.pro_name}
            onChange={(e) => setForm({ ...form, pro_name: e.target.value })}
          />
          <TextField
            margin="dense"
            label="Price"
            type="number"
            fullWidth
            value={form.pro_price}
            onChange={(e) => setForm({ ...form, pro_price: e.target.value })}
          />
          <input
            type="file"
            accept="image/*"
            onChange={(e) => setForm({ ...form, photo: e.target.files[0] })}
            style={{ marginTop: "1rem" }}
          />
        </DialogContent>
        <DialogActions>
          <Button  variant="contained" onClick={() => setOpenDialog(false)}>Cancel</Button>
          <Button variant="contained" onClick={handleSubmit}>Save</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default MyProductsPage;
