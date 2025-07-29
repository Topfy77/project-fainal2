import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' as foundation; // เพิ่มการ import นี้
import 'dart:html' as html; // สำหรับ Web
import 'dart:typed_data'; // เพิ่มการ import นี้สำหรับ Uint8List
import '../models/product.dart';

class ApiService with ChangeNotifier {
  List<Product> _products = [];
  int? _userId;
  String? _token;
  bool _isLoading = false;

  List<Product> get products => _products;
  int? get userId => _userId;
  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<void> loginWithApi(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          _token = data['token'];
          _userId = data['user']['user_id'];
          notifyListeners();
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllProducts() async {
    if (_token == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _products = data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch all products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Fetch all products error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyProducts() async {
    if (_token == null || _userId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/products/my-products?user_id=$_userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _products = data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch my products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Fetch my products error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(String proName, int proPrice, int proQty, dynamic photo) async {
    if (_token == null || _userId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/api/products'),
      );
      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['pro_name'] = proName;
      request.fields['pro_price'] = proPrice.toString();
      request.fields['pro_qty'] = proQty.toString();
      request.fields['user_id'] = _userId.toString();

      if (photo != null) {
        if (foundation.kIsWeb) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(photo);
          await reader.onLoad.first;
          final bytes = reader.result as Uint8List; // ใช้ Uint8List ได้หลัง import
          request.files.add(http.MultipartFile.fromBytes(
            'photo',
            bytes,
            filename: photo.name, // ใช้ชื่อไฟล์จาก html.File
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'photo',
            (photo as File).path,
            filename: path.basename((photo as File).path),
          ));
        }
        print('Uploading photo: ${photo.name ?? photo.path}');
      }

      var response = await request.send().timeout(Duration(seconds: 15));
      var responseBody = await response.stream.bytesToString();
      print('Add product response: $responseBody');
      if (response.statusCode == 200) {
        await fetchMyProducts();
      } else {
        throw Exception('Failed to add product: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Add error: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(int proId, String proName, int proPrice, int proQty, dynamic photo) async {
    if (_token == null || _userId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://localhost:3000/api/products/$proId'),
      );
      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['pro_name'] = proName;
      request.fields['pro_price'] = proPrice.toString();
      request.fields['pro_qty'] = proQty.toString();
      request.fields['user_id'] = _userId.toString();

      if (photo != null) {
        if (foundation.kIsWeb) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(photo);
          await reader.onLoad.first;
          final bytes = reader.result as Uint8List; // ใช้ Uint8List ได้หลัง import
          request.files.add(http.MultipartFile.fromBytes(
            'photo',
            bytes,
            filename: photo.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'photo',
            (photo as File).path,
            filename: path.basename((photo as File).path),
          ));
        }
        print('Uploading photo: ${photo.name ?? photo.path}');
      }

      var response = await request.send().timeout(Duration(seconds: 15));
      var responseBody = await response.stream.bytesToString();
      print('Update product response: $responseBody');
      if (response.statusCode == 200) {
        await fetchMyProducts();
      } else {
        throw Exception('Failed to update product: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Update error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int proId) async {
    if (_token == null || _userId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/products/$proId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        await fetchMyProducts();
      } else {
        throw Exception('Failed to delete product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Delete error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}