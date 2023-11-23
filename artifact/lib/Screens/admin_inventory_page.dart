import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminInventoryPage extends StatefulWidget {
  const AdminInventoryPage({Key? key}) : super(key: key);

  @override
  State<AdminInventoryPage> createState() => _AdminInventoryPageState();
}

class _AdminInventoryPageState extends State<AdminInventoryPage> {
  final String _apiHost = 'http://localhost:8083';
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    var url = Uri.parse('$_apiHost/inventory/list');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _items = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network error: $e');
    }
  }

  Future<void> addItem(String item, String number, String gender, String size) async {
    var url = Uri.parse('$_apiHost/inventory/add?requester=WJaPdCb3ltRF1IdlJdBjqYJT3t32');
    try {
      var response = await http.post(url, body: {
        'item': item,
        'number': number,
        'gender': gender,
        'size': size,
      });
      if (response.statusCode == 200) {
        fetchInventory(); // Refresh the list
      } else {
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network error: $e');
    }
  }

  Future<void> updateItem(String item, String number, String gender, String size) async {
    var url = Uri.parse('$_apiHost/inventory/update?requester=WJaPdCb3ltRF1IdlJdBjqYJT3t32&item=$item&number=$number&gender=$gender&size=$size');
    try {
      var response = await http.put(url);
      if (response.statusCode == 200) {
        fetchInventory(); // Refresh the list
      } else {
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network error: $e');
    }
  }

  Future<void> removeItem(String item, String gender, String size) async {
    var url = Uri.parse('$_apiHost/inventory/remove?item=$item&gender=$gender&size=$size');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        fetchInventory(); // Refresh the list
      } else {
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Inventory'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item['item']),
            subtitle: Text('Size: ${item['size']} - Gender: ${item['gender']}'),
            trailing: Text('Quantity: ${item['number']}'),
            onTap: () {
              // For simplicity, just calling removeItem here, but you should implement proper UI for CRUD operations
              removeItem(item['item'], item['gender'], item['size']);
            },
          );
        },
      ),
    );
  }
}
