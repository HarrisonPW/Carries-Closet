import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final _MyApiWidgetState myApiWidget = _MyApiWidgetState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Inventory List'),
          backgroundColor: Colors.blue,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  myApiWidget.showAddItemDialog(context);
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: MyApiWidget(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                _MyApiWidgetState.refreshData(context);
              },
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApiWidget extends StatefulWidget {
  const MyApiWidget({super.key});
  @override
  State<MyApiWidget> createState() => _MyApiWidgetState();
}

class _MyApiWidgetState extends State<MyApiWidget> {
  String newItem = '';
  String newNumber = '';
  String selectedGender = 'Male';
  String selectedSize = 'XS';

  Future<void> showAddItemDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Item'),
                onChanged: (value) {
                  newItem = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Number'),
                onChanged: (value) {
                  newNumber = value;
                },
              ),
              DropdownButton<String>(
                value: selectedGender,
                onChanged: (String? value) {
                  if (value != null) {
                    selectedGender = value;
                  }
                },
                items: ['Male', 'Female']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              DropdownButton<String>(
                value: selectedSize,
                onChanged: (String? value) {
                  selectedSize = value!;
                },
                items: ['XS', 'XXS', 'Small', 'Medium', 'Large', 'XL', 'XXL']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String addUrl =
                    "http://172.16.0.10:8083/inventory/add?requester=WJaPdCb3ltRF1IdlJdBjqYJT3t32";
                var urlResponse = Uri.parse(addUrl);

                var request = http.MultipartRequest('Post', urlResponse);

                request.fields['gender'] = selectedGender;
                request.fields['size'] = selectedSize;
                request.fields['number'] = newNumber;
                request.fields['item'] = newItem;

                try {
                  var sendResponse = await request.send();
                  if (sendResponse.statusCode == 200) {
                    runApp(MyApp());
                    print(
                        "Add Success!! Item: $newItem, Number: $newNumber, Gender: $selectedGender, Size: $selectedSize");
                  }
                } catch (e) {
                  print("Add failed. Error: $e");
                }
                ;
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> refreshData(BuildContext context) async {
    print('Data refreshed!');
    runApp(MyApp());
  }

  final String apiUrl = "http://172.16.0.10:8083/inventory/list";
  static Future<List<String>> getDataFromApi(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<String> stringList2 = data.map((item) {
          return "Gender: ${item['gender']}\n     Item: ${item['item']}\n     Number: ${item['number']}\n     Size: ${item['size']}\n     ";
        }).toList();
        return stringList2;
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("An error occurred: $e");
      return [];
    }
  }

  Future<List<dynamic>> getRawJSON(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getDataFromApi(apiUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${index + 1}. ${data[index]}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              List<dynamic> rawData = await getRawJSON(apiUrl);
                              onEditButtonPressed(context, index, rawData);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              List<dynamic> rawData2 = await getRawJSON(apiUrl);
                              onDeleteButtonPressed(index, rawData2);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget ok = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Number Updated!"),
      actions: [
        ok,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onEditButtonPressed(
      BuildContext context, int index, List<dynamic> data) async {
    if (index >= 0 && index < data.length) {
      String item = data[index]['item'];
      String size = data[index]['size'];
      String gender = data[index]['gender'];
      String initialValue = "";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditForm(
            initialValue: initialValue,
            onSave: (updatedValue) async {
              try {
                final editResponse = await http.put(Uri.parse(
                    "http://172.16.0.10:8083/inventory/update?item=$item&number=$updatedValue&size=$size&gender=$gender"));
                if (editResponse.statusCode == 200) {
                  runApp(MyApp());
                  print(
                      "it edit button went through, the input value is $updatedValue");
                  showAlertDialog(context);
                }
              } catch (e) {
                print("Edit button error: $e");
                return;
              }
            },
          );
        },
      );
    }
  }

  Future<void> onDeleteButtonPressed(int index, List<dynamic> data) async {
    String item = data[index]['item'];
    String size = data[index]['size'];
    String gender = data[index]['gender'];
    try {
      final deleteResponse = await http.delete(Uri.parse(
          "http://172.16.0.10:8083/inventory/remove?item=$item&size=$size&gender=$gender"));
      if (deleteResponse.statusCode == 200) {
        print("Data updated!");
        runApp(MyApp());
      }
    } catch (e) {
      print("$e");
      return;
    }
  }
}

class EditForm extends StatefulWidget {
  final String initialValue;
  final Function(String) onSave;

  const EditForm({Key? key, required this.initialValue, required this.onSave})
      : super(key: key);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Item Number'),
      content: TextFormField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'New Value'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
