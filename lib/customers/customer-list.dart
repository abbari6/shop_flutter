import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:home_shop/customers/details.dart';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final _formKey = GlobalKey<FormBuilderState>();

  List list = [
    "Flutter",
    "React",
    "Ionic",
    "Xamarin",
  ];
  final String apiUrl = "https://home-project.onrender.com/customer/list";
  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body);
  }

  String _name(dynamic customer) {
    return customer['name'];
  }

  int _balance(dynamic customer) {
    return customer['balance'];
  }

  String _id(dynamic customer) {
    return customer['_id'];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                fetchUsers();
              });
            },
          )
        ],
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton(
          // onPressed: openFilterDialog,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Center(
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FormBuilderTextField(
                                  name: 'name',
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: 'balance',
                                  initialValue: "0",
                                  decoration: const InputDecoration(
                                    labelText: 'Balance',
                                    icon: Icon(Icons.currency_rupee),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: const Text("Submit"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState?.save();
                                        final formData =
                                            _formKey.currentState?.value;
                                        final http.Response response =
                                            await http.post(
                                                Uri.parse(
                                                    'https://home-project.onrender.com/customer/add'),
                                                headers: <String, String>{
                                                  'Content-Type':
                                                      'application/json; charset=UTF-8',
                                                },
                                                body: jsonEncode(formData));
                                        if (response.statusCode == 201) {
                                          setState(() {
                                            fetchUsers();
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Details(id: _id(snapshot.data[index]))),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(_name(snapshot.data[index]).toUpperCase()),
                              trailing: Text(
                                  _balance(snapshot.data[index]).toString()),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
