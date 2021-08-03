import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:new_app_2/Helper/FireStoreHelper.dart';
import 'package:new_app_2/Helper/FirebaseStorageHelper.dart';
import 'package:new_app_2/Helper/GeneralUtils.dart';
import 'package:new_app_2/Helper/searchUtils.dart';

class AdminHelper {
  static void addNews(
    BuildContext context, {
    String? titleVal,
    String? descreptionVal,
    String? imageUrl,
    String? id,
    String? categorieValue,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddArticle(
            titleVal: titleVal,
            descreptionVal: descreptionVal,
            imageUrl: imageUrl,
            id: id,
            categorieValue: categorieValue,
          );
        },
      ),
    );
  }

  static void addCategorie(BuildContext context) async {
    var textController = TextEditingController();
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Categorie'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter Categorie',
            labelText: 'Categorie',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            icon: Icon(Icons.close),
            label: Text('Close'),
            style: TextButton.styleFrom(
              primary: Colors.redAccent,
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              if (textController.text.trim().isEmpty) return;
              await FireStoreHepler.addCategorie(textController.text.trim());
              Navigator.of(ctx).pop();
            },
            icon: Icon(Icons.add),
            label: Text('Add'),
          ),
        ],
      ),
    );
  }

  static void editArticles(
    BuildContext context,
  ) {
    showSearch(
        context: context,
        delegate: DataSearch(false, (
          String? titleVal,
          String? descreptionVal,
          String? imageUrl,
          String? id,
          String? categorieValue,
        ) {
          addNews(
            context,
            titleVal: titleVal,
            descreptionVal: descreptionVal,
            imageUrl: imageUrl,
            id: id,
            categorieValue: categorieValue,
          );
        }));
  }

  static void deleteArticles(context) {
    showSearch(
        context: context,
        delegate: DataSearch(false, (
          String? titleVal,
          String? descreptionVal,
          String? imageUrl,
          String? id,
          String? categorieValue,
        ) async {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are you sure you wnat to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FireStoreHepler.deleteArticle(id!);
                          Navigator.of(ctx).pop();
                        },
                        child: Text('YES'),
                        style: TextButton.styleFrom(primary: Colors.red),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('NO'),
                      ),
                    ],
                  ));
        }));
  }
}

class AddArticle extends StatefulWidget {
  final String? titleVal;
  final String? descreptionVal;
  final String? imageUrl;
  final String? id;
  final String? categorieValue;

  const AddArticle(
      {Key? key,
      this.titleVal,
      this.descreptionVal,
      this.imageUrl,
      this.id,
      this.categorieValue})
      : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  bool? isAdd;
  String? title;
  String? descreption;
  String? categorie;
  Image? image;
  String? path = '';
  PickedFile? picked;

  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    isAdd = widget.titleVal == null;
    title = widget.titleVal;
    descreption = widget.descreptionVal;
    categorie = widget.categorieValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd! ? 'Add News' : 'Edit News'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            StatefulBuilder(builder: (ctxSta, setSta) {
              return Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: image != null
                        ? image
                        : isAdd!
                            ? Center(
                                child: Text(
                                  'Choose Picture',
                                  style: TextStyle(fontSize: 25),
                                ),
                              )
                            : Image.network(widget.imageUrl!),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          picked = (await ImagePicker().getImage(
                              source: ImageSource.camera, imageQuality: 65))!;
                          path = picked!.path;

                          image = kIsWeb
                              ? Image.network(path!)
                              : Image.file(File(path!));
                          setSta(() {});
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Camera'),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          picked = (await ImagePicker().getImage(
                              source: ImageSource.gallery, imageQuality: 65))!;
                          path = picked?.path;

                          image = kIsWeb
                              ? Image.network(path!)
                              : Image.file(File(path!));
                          setSta(() {});
                        },
                        icon: Icon(Icons.photo),
                        label: Text('Gallery'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          image = null;
                          path = '';
                          picked = null;
                          setSta(() {});
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Reset'),
                      )
                    ],
                  ),
                ],
              );
            }),
            TextFormField(
              initialValue: title ?? '',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusColor: Theme.of(context).accentColor,
                hintText: 'Enter Title',
                labelText: 'Title',
              ),
              validator: (str) {
                if (str!.trim().isEmpty) return 'The Title cannot be empty';
                return null;
              },
              onSaved: (str) => title = str,
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FireStoreHepler.categories(),
                builder: (contextSt,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final docs = snapshot.data!.docs;
                  categorie = categorie ?? docs[0]['value'];
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      padding: EdgeInsets.only(right: 100),
                      child: DropdownButton<String>(
                        menuMaxHeight: 200,
                        value: categorie,
                        items: docs
                            .map(
                              (e) => DropdownMenuItem<String>(
                                child: Text(
                                  e['value'],
                                ),
                                value: e['value'],
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            categorie = val;
                          });
                        },
                        itemHeight: 50,
                        hint: Text('Categories'),
                      ),
                    );
                  });
                }),
            TextFormField(
              maxLines: 5,
              initialValue: descreption ?? '',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusColor: Theme.of(context).accentColor,
                hintText: 'Enter Descreption',
                labelText: 'Descreption',
              ),
              validator: (str) {
                if (str!.trim().isEmpty)
                  return 'The Descreption cannot be empty';
                return null;
              },
              onSaved: (str) => descreption = str,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (!formKey.currentState!.validate() ||
                      (image == null && widget.imageUrl == null)) return;
                  formKey.currentState!.save();
                  Utils.showLoading(context);
                  if (isAdd!)
                    await FireStoreHepler.addNewArticle(
                      await FireStorage.imageUrl(picked!),
                      title!,
                      descreption!,
                      categorie!,
                    );
                  else
                    await FireStoreHepler.editArticle(
                      image != null
                          ? await FireStorage.imageUrl(picked!)
                          : widget.imageUrl!,
                      title!,
                      descreption!,
                      widget.id!,
                      categorie!,
                    );

                  Navigator.of(context).pop();
                  Utils.closeLoading();
                } catch (e) {
                  Utils.showSnackBar(context, e);
                }
              },
              child: Text(isAdd! ? 'ADD' : 'Edit'),
            )
          ],
        ),
      ),
    );
  }
}
