import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import ' category.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cats> categories = [];
  bool isLoading = false;
  String selectedCategoryId = "";

  TextEditingController addItemController = TextEditingController();
  TextEditingController editItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial data when the widget is first created
    getSchedule();
  }

  Future<void> getSchedule() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(Uri.parse("http:youripv4/api/get.php"));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          categories.clear();
          for (var category in jsonData) {

            final cat = Cats (
              Id: category['id'].toString(),
              Name: category['name'].toString(),
            );
            categories.add(cat);
          }
        });
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (error) {
      print("Error in getSchedule: $error");
      // Handle error as needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse("http:youripv4/api/post.php");

      final Map<String, String> data = {
        'name': addItemController.text,
      };

      final response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 200) {
        print("Data posted successfully");
        getSchedule();
      } else {
        print("Failed to post data");
      }
    } catch (error) {
      print("Error in postData: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateCategory(String categoryId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final encodedCategoryId = Uri.encodeComponent(categoryId);
      final Uri url = Uri.parse("http:youripv4/api/update.php?id=$encodedCategoryId");

      final Map<String, String> data = {
        'name': editItemController.text,
      };

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Data updated successfully");
        getSchedule();
      } else {
        print("Failed to update data");
      }
    } catch (error) {
      print("Error in updateCategory: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  Future<void> deleteCategory(String categoryId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final encodedCategoryId = Uri.encodeComponent(categoryId);
      final Uri url = Uri.parse("http:youripv4/api/delete.php?id=$encodedCategoryId");

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Data deleted successfully");
        getSchedule();
      } else {
        print("Failed to delete data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error in deleteCategory: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void openAddBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addItemController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              postData();

              addItemController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void openEditBox(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });

    editItemController.text = categories
        .firstWhere((cat) => cat.Id == categoryId, orElse: () => Cats(Name: "", Id: ''))
        .Name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editItemController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              updateCategory(selectedCategoryId);

              addItemController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Items")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddBox();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => postData(),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blueGrey.shade400,
                child: const Icon(
                  Icons.telegram,
                  size: 75,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: categories.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(categories[index].Id.toString()),
                        subtitle: Text(categories[index].Name.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                openEditBox(categories[index].Id);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteCategory(categories[index].Id);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
