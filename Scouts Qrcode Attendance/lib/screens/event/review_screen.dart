import 'package:asdt_app/classes/event.dart';
import 'package:asdt_app/classes/user.dart';
import 'package:asdt_app/helpers/firebase_firestore.dart';
import 'package:asdt_app/helpers/providers/user_review_provider.dart';
import 'package:asdt_app/widgets/custom_listview.dart';
import 'package:asdt_app/widgets/custom_loading_button.dart';
import 'package:asdt_app/widgets/custom_scaffold.dart';
import 'package:asdt_app/widgets/custom_textformfield.dart';
import 'package:asdt_app/widgets/loading_error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});
  static const routeName = '/ReviewScreen';

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = data['user'] as AppUser;
    final event = data['event'] as Event;
    return CustomScaffold(
      appBar: AppBar(title: Text("Review")),
      body: FutureBuilder(
          future: FirebaseFirestoreHelper.getReviewByUserEmail(
              user.email, event.id!),
          builder: (_, snapshot) {
            return LoadingErrorHandling(
              builder: () {
                final reviews = snapshot.data!;
                final noReviewsYet = reviews.isEmpty;
                return ChangeNotifierProvider(
                  create: (_) => noReviewsYet
                      ? AppUserReviewProvider.withEmailAndId(
                          user.email, event.id!)
                      : AppUserReviewProvider(reviews[0].data()),
                  builder: (ctx, _2) {
                    final appReview = Provider.of<AppUserReviewProvider>(ctx);
                    return CustomListView(
                      children: [
                        SwitchListTile.adaptive(
                          title: Text("ElZy"),
                          value: appReview.getIsCostume,
                          onChanged: appReview.setIsCostume,
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile.adaptive(
                          title: Text("Church"),
                          value: appReview.getIsChurch,
                          onChanged: appReview.setIsChurch,
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile.adaptive(
                          title: Text("Sharing"),
                          value: appReview.getIsSharing,
                          onChanged: appReview.setIsSharing,
                          contentPadding: EdgeInsets.zero,
                        ),
                        Form(
                          key: appReview.formKey,
                          child: CustomTextFormField(
                            initialValue: appReview.getExcuse,
                            onSaved: appReview.setExcuse,
                            type: CustomTextInputType.excuse,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomLoadingButton(
                          onPressed: () async {
                            if (await appReview.saveReview) {
                              Navigator.of(context).pop();
                            }
                          },
                          text: 'Save',
                          icon: Icon(Icons.save_alt_rounded),
                        ),
                      ],
                    );
                  },
                );
              },
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              isError: snapshot.hasError,
            );
          }),
    );
  }
}
