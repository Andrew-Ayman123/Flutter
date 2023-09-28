import 'dart:math';

import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/helpers/dialog.dart';
import 'package:asdt_app/helpers/firebase_auth.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/format.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.receivedUser});
  final AppUser? receivedUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: receivedUser == null ? FirebaseFirestoreHelper.profileGet : null,
      builder: (ctx, AsyncSnapshot<AppUser> snapshot) {
        return LoadingErrorHandling(
            builder: () {
              AppUser user = receivedUser ?? snapshot.data!;
              final double imageRadius =
                  min(MediaQuery.of(context).size.width * .25, 200);
              final textStyle = Theme.of(context).textTheme.subtitle2;
              return Center(
                child: CustomListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        DialogHelper.displayImage(
                          image: Image.network(user.imageLink),
                          context: context,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: imageRadius + 5,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: imageRadius,
                              backgroundImage: NetworkImage(user.imageLink),
                            ),
                            //QR Image
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  DialogHelper.displayImage(
                                    image: QrImage(
                                      padding: EdgeInsets.zero,
                                      data: user.email,
                                      backgroundColor:
                                          Colors.white.withOpacity(.85),
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      version: QrVersions.auto,
                                      embeddedImage: const AssetImage(
                                          'assets/images/logo_center.png'),
                                      embeddedImageStyle: QrEmbeddedImageStyle(
                                          size: const Size(150, 175),
                                          color: Colors.black),
                                    ),
                                    context: context,
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 25,
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      'assets/images/qr-code.png',
                                    ),
                                    radius: 22,
                                    child: Text(
                                      'QR',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Name: ${user.name}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    if (user.nickName.isNotEmpty) ...{
                      Text(
                        'Nickname: ${user.nickName}',
                        style: textStyle,
                      ),
                      const SizedBox(height: 8),
                    },
                    Text(
                      'Group: ${user.groupName}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: ${FormatHelper.formatPhoneNumber(user.phoneNumber)}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'E-Mail: ${user.email}',
                      style: textStyle,
                    ),
                    const SizedBox(height: 8),
                    if (receivedUser == null) ...{
                      ElevatedButton.icon(
                          onPressed: FirebaseAuthHelper.logout,
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'))
                    }
                  ],
                ),
              );
            },
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            isError: snapshot.hasError);
      },
    );
  }
}
