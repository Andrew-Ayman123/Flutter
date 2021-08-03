import 'dart:io';
import 'package:chat_app/Utils/AuthScreenUtils.dart';
import 'package:chat_app/widgets/FadeWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectingPicture extends StatefulWidget {
  @override
  _SelectingPictureState createState() => _SelectingPictureState();
}

class _SelectingPictureState extends State<SelectingPicture> {
  File selectedImage;

  //widget.imageSelection(selectedImage);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FadeInWidget(
            duration: Duration(milliseconds: 500),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              backgroundImage: selectedImage != null
                  ? FileImage(
                      selectedImage,
                    )
                  : AssetImage('Assets/Images/No Profile.jpg'),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final image = await ImagePicker()
                  .getImage(source: ImageSource.camera, imageQuality: 50);
              setState(() {
                selectedImage = File(image.path);
              });
              Provider.of<RegistrationUtils>(context, listen: false)
                  .insertImageData(selectedImage);
            },
            icon: Icon(Icons.camera),
            label: Text('Camera'),
          ),
          TextButton.icon(
            onPressed: () async {
              final image = await ImagePicker()
                  .getImage(source: ImageSource.gallery, imageQuality: 50);
              setState(() {
                selectedImage = File(image.path);
              });
              Provider.of<RegistrationUtils>(context, listen: false)
                  .insertImageData(selectedImage);
            },
            icon: Icon(Icons.photo_size_select_actual_rounded),
            label: Text('Gallery'),
          ),
          TextButton.icon(
            onPressed: () async {
              setState(() {
                selectedImage = null;
              });
              Provider.of<RegistrationUtils>(context, listen: false)
                  .insertImageData(null);
            },
            icon: Icon(Icons.restore),
            label: Text('reset'),
          ),
        ],
      ),
    );
  }
}
