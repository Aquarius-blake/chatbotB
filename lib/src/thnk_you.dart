import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ThankYouWidget extends StatefulWidget {
  final String smtpUsername; // Your email
  final String smtpPassword; // Your password
  final String smtpServer; // SMTP server address
  final int smtpPort; // SMTP port (usually 587 for TLS)
  final bool isSecure;
  final String senderName;
  final String recipient;
  final String subject;
  final String body;
  final Color ratingBackgroundColor;
  final String ratingText;
  final Icon ratingIconYes;
  final Icon ratingIconNo;
  final Color ratingIconColor;
  final String thankYouText;
  final String ratingTitle;

  const ThankYouWidget({
    super.key,
    required this.recipient,
    required this.body,
    required this.subject,
    required this.ratingIconNo,
    required this.ratingIconYes,
    required this.ratingBackgroundColor,
    required this.ratingIconColor,
    required this.ratingTitle,
    required this.ratingText,
    required this.isSecure,
    required this.smtpPort,
    required this.smtpServer,
    required this.smtpPassword,
    required this.smtpUsername,
    required this.senderName,
    required this.thankYouText,
  });

  @override
  State<ThankYouWidget> createState() => _ThankYouWidgetState();
}

class _ThankYouWidgetState extends State<ThankYouWidget> {
  int _selectedRating = 0;
  int _hoveredRating = 0;

  Future<void> sendMail() async {
    final String smtpUsername = widget.smtpUsername; // Your email
    final String smtpPassword = widget.smtpPassword; // Your password
    final String smtpServer = widget.smtpServer; // SMTP server address
    final smtpPort = widget.smtpPort; // SMTP port (usually 587 for TLS)
    final isSecure =
        widget.isSecure; // Use TLS (true for TLS, false for non-secure)
    final server = SmtpServer(
      smtpServer,
      username: smtpUsername,
      password: smtpPassword,
      port: smtpPort,
      ssl: isSecure,
      allowInsecure: true,
    );

    final message = Message()
      ..from = Address(smtpUsername, widget.senderName)
      ..recipients.add(widget.recipient) // Recipient's email
      ..subject = widget.subject
      ..text = widget.body;

    try {
      final sendReport = await send(message, server);
      _showSnackBar(
        'Message sent: ${sendReport.toString()}\nRated: $_selectedRating stars',
        true,
      );
      _showThankYouMessage(); // Show the thank you message after sending
    } catch (e) {
      _showSnackBar('Error occurred: $e', false);
    }
  }

  void _showThankYouMessage() {
    final message = 'Thank you for rating $_selectedRating stars!';
    _showSnackBar(message, true);
  }

  void _showSnackBar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: widget.ratingBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.ratingTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (_selectedRating == 0)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.ratingText),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final isFilled = index < _selectedRating;
                    final isHovered = index < _hoveredRating;

                    return MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hoveredRating = index + 1;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _hoveredRating = 0;
                        });
                      },
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Update _selectedRating based on user selection
                            if (_selectedRating == index + 1) {
                              _selectedRating =
                                  0; // Deselect the star if already selected
                            } else {
                              _selectedRating =
                                  index + 1; // Update the selected rating
                            }
                          });
                        },
                        child: Icon(
                          // Determine the icon based on user's selection and hover state
                          isFilled || isHovered
                              ? widget.ratingIconYes.icon
                              : widget.ratingIconNo.icon,
                          color: widget.ratingIconColor,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    sendMail();
                  },
                  child: Text(widget.thankYouText),
                ),
              ],
            )
          else
            Center(child: Text(widget.ratingTitle)),
        ],
      ),
    );
  }
}
