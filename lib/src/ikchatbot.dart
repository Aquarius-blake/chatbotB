import 'dart:async';
import 'package:flutter/material.dart';
import '../ikchatbot.dart';
//import 'package:flutter_tts/flutter_tts.dart';

// ignore: camel_case_types
class ikchatbot extends StatefulWidget {
  final IkChatBotConfig config;

  const ikchatbot({Key? key, required this.config}) : super(key: key);

  @override
  State<ikchatbot> createState() => _ikchatbotState();
}

// ignore: camel_case_types
class _ikchatbotState extends State<ikchatbot> {
  // FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  Timer? _inactivityTimer;
  Timer? _closeTimer;
  bool _isWaitingForUserResponse = true;
  bool _conversationOver = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(widget.config.initialGreeting);
    _startInactivityTimer();
    // flutterTts = FlutterTts();
    //initTTS();
  }

  // Future<void> initTTS() async {
  //   if (flutterTts != null) {
  //     await flutterTts!.setLanguage('en-US');
  //     await flutterTts!.setPitch(1.0);
  //     await flutterTts!.setSpeechRate(1.0);
  //   }
  // }

  // Future<void> speak(String text) async {
  //   if (text.isNotEmpty && flutterTts != null) {
  //     await flutterTts!.speak(text);
  //     setState(() {
  //       isSpeaking = true;
  //     });
  //   }
  // }

  // Future<void> stopSpeaking() async {
  //   if (flutterTts != null) {
  //     await flutterTts!.stop();
  //     setState(() {
  //       isSpeaking = false;
  //     });
  //   }
  // }

  void _addBotMessage(String text) {
    final botMessage = ChatMessage(
      botColor: widget.config.botChatColor,
      botIcon: widget.config.botIcon,
      userColor: widget.config.userChatColor,
      userIcon: widget.config.userIcon,
      bottextcolor: widget.config.bottextcolor,
      usertextcolor: widget.config.usertextcolor,
      text: text,
      isUser: false,
      messageTime: DateTime.now(),
    );
    setState(() {
      _messages.add(botMessage);
      // if (widget.config.useAsset == true) {
      //   //speak(text);
      // }
    });
  }

  void _handleSubmitted(String text) {
    _inactivityTimer?.cancel();
    _closeTimer?.cancel();

    if (_isWaitingForUserResponse) {
      _handleUserResponse(text);
      return;
    }

    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        botColor: widget.config.botChatColor,
        botIcon: widget.config.botIcon,
        userColor: widget.config.userChatColor,
        userIcon: widget.config.userIcon,
        bottextcolor: widget.config.bottextcolor,
        usertextcolor: widget.config.usertextcolor,
        text: text,
        isUser: true,
        messageTime: DateTime.now(),
      ));
    });

    _textController.clear();

    // Scroll to the end of the list after adding a new message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: widget.config.delayBot),
      curve: Curves.easeOut,
    );

    Future.delayed(Duration(minutes: widget.config.closingTime), () {
      _handleUserResponse(text);
    });
  }

  void _handleUserResponse(String response) {
    final lowerCaseResponse = response.trim().toLowerCase();

    String reply;
    String userSelectedOption;

    final int index = _findMatchingKeyword(lowerCaseResponse);

    if (index != -1) {
      userSelectedOption = response;
      reply = widget.config.responses[index];
    } else {
      userSelectedOption = response;
      reply = widget.config.defaultResponse;
    }

    setState(() {
      _messages.add(ChatMessage(
        botColor: widget.config.botChatColor,
        botIcon: widget.config.botIcon,
        userColor: widget.config.userChatColor,
        userIcon: widget.config.userIcon,
        bottextcolor: widget.config.bottextcolor,
        usertextcolor: widget.config.usertextcolor,
        text: userSelectedOption,
        isUser: true,
        messageTime: DateTime.now(),
      ));

      _textController.clear();
    });

    if (reply.isNotEmpty) {
      _isWaitingForUserResponse = false;
      _startTypingAnimation(reply);
    }
  }

  int _findMatchingKeyword(String response) {
    for (int i = 0; i < widget.config.keywords.length; i++) {
      if (response.contains(widget.config.keywords[i])) {
        return i;
      }
    }
    return -1;
  }

  void _startTypingAnimation(String reply) {
    final typingMessage = ChatMessage(
      botColor: widget.config.botChatColor,
      botIcon: widget.config.botIcon,
      userColor: widget.config.userChatColor,
      bottextcolor: widget.config.bottextcolor,
      usertextcolor: widget.config.usertextcolor,
      userIcon: widget.config.userIcon,
      text: widget.config.waitingText,
      isUser: false,
      messageTime: DateTime.now(),
    );

    setState(() {
      _messages.add(typingMessage);
    });

    Future.delayed(Duration(seconds: widget.config.delayResponse), () {
      // Simulating a delay for the typing animation
      _messages.remove(typingMessage); // Remove the "Typing..." message
      _addBotMessage(reply); // Add the actual bot response
      _startInactivityTimer(); // Start the inactivity timer

      if (reply == widget.config.closingMessage) {
        setState(() {
          _conversationOver = true;
        });
      }
    });
  }

  void _startInactivityTimer() {
    _inactivityTimer = Timer(Duration(minutes: widget.config.waitingTime), () {
      if (!_isWaitingForUserResponse) {
        _addBotMessage(widget.config.inactivityMessage);
        _isWaitingForUserResponse = true;
        _startInactivityTimer();
      } else {
        _startCloseTimer();
      }
    });
  }

  void _startCloseTimer() {
    _closeTimer = Timer(Duration(minutes: widget.config.closingTime), () {
      setState(() {
        _conversationOver = true; // Mark conversation as over
        _addBotMessage(widget.config.closingMessage); // Add closing message
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _conversationOver
          ? ThankYouWidget(
              ratingBackgroundColor: widget.config.ratingBackgroundColor,
              ratingIconColor: widget.config.ratingIconColor,
              ratingIconYes: widget.config.ratingIconYes,
              ratingTitle: widget.config.ratingTitle,
              ratingText: widget.config.ratingText,
              smtpPort: widget.config.smtpPort,
              smtpServer: widget.config.smtpServer,
              smtpUsername: widget.config.smtpUsername,
              smtpPassword: widget.config.smtpPassword,
              senderName: widget.config.senderName,
              isSecure: widget.config.isSecure,
              recipient: widget.config.recipient,
              subject: widget.config.subject,
              body: widget.config.body,
              ratingIconNo: widget.config.ratingIconNo,
              thankYouText: widget.config.thankyouText,
            ) // Display ThankYouWidget if conversation is over
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.config.backgroundAssetimage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemBuilder: (_, int index) =>
                            _messages.reversed.toList()[index],
                        itemCount: _messages.length,
                      ),
                    ),
                  ),
                  const Divider(height: 1.0),
                  _buildTextComposer(),
                ],
              ),
            ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.config.backgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  if (!_isWaitingForUserResponse) {
                    _isWaitingForUserResponse = true;
                  }
                },
                decoration: InputDecoration.collapsed(
                  hintText: widget.config.inputHint,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
              ),
              onPressed: () {
                _handleSubmitted(_textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _closeTimer?.cancel();
    // if (flutterTts != null) {
    //   stopSpeaking();
    // }
    super.dispose();
  }
}
