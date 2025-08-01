import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'all_products_screen.dart';
import 'my_products_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    AllProductsScreen(),
    MyProductsScreen(),
  ];

  static final List<String> _titles = <String>[
    'All Products',
    'My Products',
  ];

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    if (_selectedIndex == 0) {
      apiService.fetchAllProducts();
    } else {
      apiService.fetchMyProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.blue[800],
        elevation: 6,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue[800]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User: top',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.blue[800]),
              title: Text('All Products', style: TextStyle(fontSize: 16)),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  Provider.of<ApiService>(context, listen: false).fetchAllProducts();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue[800]),
              title: Text('My Products', style: TextStyle(fontSize: 16)),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  Provider.of<ApiService>(context, listen: false).fetchMyProducts();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}