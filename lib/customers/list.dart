import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';

class ListOfInterests extends StatefulWidget {
  const ListOfInterests({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListOfInterestsState();
  }
}

class ListOfInterestsState extends State<ListOfInterests> {
  List<String> interest = [
    'Hiking',
    'Camping',
    'sports',
    'Food',
    'Shopping',
    'Lakes',
    'Trekking',
    'Swimming'
  ];
  List<String>? selectedUserList = [];
  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: interest,
      selectedListData: selectedUserList,
      choiceChipLabel: (user) => user!,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (user, query) {
        return user.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
          print(list);
        });
        Navigator.pop(context);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openFilterDialog,
        child: const Icon(Icons.add),
      ),
      body: selectedUserList == null || selectedUserList!.isEmpty
          ? const Center(child: Text('No user selected'))
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedUserList![index]),
                );
              },
              itemCount: selectedUserList!.length,
            ),
    );
  }
}
