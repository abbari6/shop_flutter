import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:home_shop/customers/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Details extends StatefulWidget {
  const Details({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Details> createState() => DetailsState();
}

class DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormBuilderState>();
  String id = "";
  late Future<Customer> customer;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    customer = fetchUser();
  }

  final String apiUrl = "https://home-project.onrender.com/customer/get/";
  Future<Customer> fetchUser() async {
    var result = await http.get(apiUrl + id);
    // return json.decode(result.body);
    return Customer.fromJson(jsonDecode(result.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Customer>(
        future: customer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(title: Text(snapshot.data!.name.toUpperCase())),
                body: Column(
                  children: [
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Balance"),
                          Text(snapshot.data!.balance.toString()),
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        clipBehavior: Clip.none,
                                        content: Stack(
                                          children: [
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
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                FormBuilder(
                                                    key: _formKey,
                                                    child: Column(
                                                      children: [
                                                        FormBuilderTextField(
                                                          name: 'paid',
                                                          keyboardType:
                                                              TextInputType.number,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      "Enter amount"),
                                                        ),
                                                        FormBuilderField(
                                                          name: "customerId",
                                                          initialValue:
                                                              snapshot.data!.id,
                                                          builder: (FormFieldState<
                                                                  dynamic>
                                                              field) {
                                                            return const SizedBox
                                                                .shrink();
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: RaisedButton(
                                                            child: const Text(
                                                                "Submit"),
                                                            onPressed: () async {
                                                              Navigator.of(context)
                                                                  .pop();
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                _formKey
                                                                    .currentState
                                                                    ?.save();

                                                                final formData =
                                                                    _formKey
                                                                        .currentState
                                                                        ?.value;
                                                                final http.Response
                                                                    response =
                                                                    await http.post(
                                                                        Uri.parse(
                                                                            'https://home-project.onrender.com/payment/add'),
                                                                        headers: <
                                                                            String,
                                                                            String>{
                                                                          'Content-Type':
                                                                              'application/json; charset=UTF-8',
                                                                        },
                                                                        body: jsonEncode(
                                                                            formData));
                                                                if (response
                                                                        .statusCode ==
                                                                    201) {
                                                                  setState(() {
                                                                    customer =
                                                                        fetchUser();
                                                                  });
                                                                }
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: const Text("Pay"))
                        ],
                      ),
                    ),
                    Expanded(child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.product.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(snapshot.data!.product[index].name),
                                      Text(snapshot.data!.product[index].price
                                          .toString()),
                                      InkWell(
                                        onTap: () {
                                          _updateItem(
                                              snapshot.data!.product[index].name,
                                              snapshot
                                                  .data!.product[index].price,
                                              snapshot.data!.product[index].id);
                                        },
                                        child: const Icon(Icons.edit, size: 15,),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    )

                  ],
                ));
          } else if (snapshot.hasError) {
            return const Text('Some thing is wrong');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addItem();
          },
          child: const Icon(Icons.add)),
    );
  }

  _addItem() {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'name',
                            decoration: const InputDecoration(
                              labelText: 'Item Name',
                              icon: Icon(Icons.production_quantity_limits),
                            ),
                          ),
                          FormBuilderTextField(
                            name: 'price',
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              icon: Icon(Icons.currency_rupee),
                            ),
                          ),
                          FormBuilderField(
                            name: "customerId",
                            initialValue: id,
                            builder: (FormFieldState<dynamic> field) {
                              return const SizedBox.shrink();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: const Text("Submit"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState?.save();
                                  final formData = _formKey.currentState?.value;
                                  final http.Response response = await http.post(
                                      Uri.parse(
                                          'https://home-project.onrender.com/product/add'),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(formData));
                                  if (response.statusCode == 202) {
                                    setState(() {
                                      customer = fetchUser();
                                    });
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _updateItem(name, price, itemId) {
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
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormBuilderTextField(
                        name: 'name',
                        initialValue: name,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          icon: Icon(Icons.production_quantity_limits),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'price',
                        initialValue: price.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
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
                              final formData = _formKey.currentState?.value;
                              final http.Response response = await http.patch(
                                  Uri.parse(
                                      'https://home-project.onrender.com/product/update/$itemId'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(formData));
                              if (response.statusCode == 202) {
                                setState(() {
                                  customer = fetchUser();
                                });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
