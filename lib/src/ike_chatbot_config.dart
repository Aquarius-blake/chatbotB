import 'package:flutter/material.dart';

class IkChatBotConfig {
  final List<String> keywords;
  final List<String> responses;
  final Color backgroundColor;
  final String backgroundImage;
  final String initialGreeting;
  final String defaultResponse;
  final String inactivityMessage;
  final String closingMessage;
  final String inputHint;
  final Color botChatColor;
  final Color userChatColor;
  int waitingTime;
  int closingTime;
  int delayResponse;
  final Icon botIcon;
  final Color bottextcolor;
  final Color usertextcolor;
  final Icon userIcon;
  final String waitingText;
  final Icon sendIcon;
  int delayBot;
  String smtpUsername;
  String smtpPassword;
  String smtpServer;
  int smtpPort;
  bool isSecure;
  String subject;
  String body;
  String recipient;
  String senderName;
  String thankyouText;
  String ratingText;
  String ratingButtonText;
  String ratingTitle;
  Icon ratingIconYes;
  Icon ratingIconNo;
  Color ratingBackgroundColor;
  Color ratingIconColor;
  bool useAsset;
  String backgroundAssetimage;

  IkChatBotConfig({
    required this.smtpUsername,
    required this.smtpPassword,
    required this.smtpServer,
    required this.smtpPort,
    required this.isSecure,
    required this.subject,
    required this.body,
    required this.recipient,
    required this.senderName,
    required this.ratingIconColor,
    required this.thankyouText,
    required this.ratingText,
    required this.ratingButtonText,
    required this.ratingTitle,
    required this.ratingIconYes,
    required this.ratingBackgroundColor,
    required this.ratingIconNo,
    required this.keywords,
    required this.responses,
    required this.backgroundColor,
    required this.backgroundImage,
    required this.initialGreeting,
    required this.defaultResponse,
    required this.inactivityMessage,
    required this.closingMessage,
    required this.inputHint,
    required this.botChatColor,
    required this.userChatColor,
    required this.waitingTime,
    required this.closingTime,
    required this.delayResponse,
    required this.botIcon,
    required this.userIcon,
    required this.waitingText,
    required this.sendIcon,
    required this.delayBot,
    required this.useAsset,
    required this.backgroundAssetimage,
    required this.bottextcolor,
    required this.usertextcolor,
  });
}
