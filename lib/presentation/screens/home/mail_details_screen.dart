import 'package:flutter/material.dart';

class MailDetailsScreen extends StatefulWidget {
  final String senderName;
  final String senderEmail;
  final String subject;
  final String body;
  final String time;

  const MailDetailsScreen({
    super.key,
    this.senderName = "Google Play",
    this.senderEmail = "no-reply@google.com",
    this.subject = "Annual reminder about Google Play terms and policies",
    this.body =
        "This is sample email content for UI.\n\nReplace with real mail body.",
    this.time = "9:39 AM",
  });

  @override
  State<MailDetailsScreen> createState() => _MailDetailsScreenState();
}

class _MailDetailsScreenState extends State<MailDetailsScreen> {
  bool expandInfo = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grey = Colors.grey.shade400;
    final systemTheme = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 23),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 23),
            onPressed: () {},
          ),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: const Text("Mark as important"),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const Text("Add to starred"),
                    onTap: () {},
                  ),
                ],
            icon: const Icon(Icons.more_vert, size: 23),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              widget.subject,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    widget.senderName[0],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.senderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      GestureDetector(
                        onTap: () {
                          setState(() => expandInfo = !expandInfo);
                        },
                        child: Row(
                          children: [
                            Text(
                              "to me",
                              style: TextStyle(fontSize: 14, color: grey),
                            ),
                            const SizedBox(width: 4),

                            AnimatedRotation(
                              turns: expandInfo ? 0.5 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Text(widget.time, style: TextStyle(color: grey, fontSize: 13)),

                const SizedBox(width: 10),

                IconButton(
                  icon: const Icon(Icons.star_border, size: 26),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                expandInfo
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      systemTheme == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("From", widget.senderEmail),
                    const SizedBox(height: 6),
                    _infoRow("To", "me"),
                    const SizedBox(height: 6),
                    _infoRow("Date", "${DateTime.now().toLocal()}"),
                  ],
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
              child: Text(
                widget.body,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ),
        ],
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.reply_outlined),
                label: const Text("Reply"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.forward_outlined),
                label: const Text("Forward"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
