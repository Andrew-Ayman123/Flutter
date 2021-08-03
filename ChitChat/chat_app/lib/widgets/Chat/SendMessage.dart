import 'package:chat_app/Utils/FireStoreHelper.dart';
import 'package:chat_app/Utils/Theme.dart';
import 'package:chat_app/widgets/SocialIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  final String chatId;
  
  SendMessage(this.chatId,);
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _textController = TextEditingController();
  bool get isFieldEmpty =>
      _textController.text == null || _textController.text.trim().isEmpty;
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  TextDirection get textBegin {
    if (_textController.text == null || _textController.text.isEmpty)
      return TextDirection.rtl;
    if (_textController.text.trim().startsWith(
          RegExp(
            '[a-z]',
            caseSensitive: false,
          ),
        ))
      return TextDirection.ltr;
    else
      return TextDirection.rtl;
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final mes = _textController.text.trim();
    _textController.clear();
    await FireStoreHelper.sendMessage(widget.chatId,mes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SocialIcon(
              colors: Provider.of<ThemeChooser>(context).gradientColors,
              func: isFieldEmpty ? () {} : sendMessage,
              icon: isFieldEmpty ? Icons.mic : Icons.send),
          Expanded(
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.only(left: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          left: isFieldEmpty ? 8 : 0,
                        ),
                        width: isFieldEmpty ? 35 : 0,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {},
                          iconSize: isFieldEmpty ? 20 : 0,
                          splashRadius: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file_rounded),
                        onPressed: () {},
                        splashRadius: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          textDirection: textBegin,
                          onChanged: (_) {
                            setState(() {});
                          },
                          minLines: 1,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Send a message...',
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
