import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:intl/intl.dart';

class MailDetailsScreen extends StatefulWidget {
  final MailModel? mail;

  const MailDetailsScreen({super.key, this.mail});

  @override
  State<MailDetailsScreen> createState() => _MailDetailsScreenState();
}

class _MailDetailsScreenState extends State<MailDetailsScreen> {
  bool expandInfo = false;

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mailDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (mailDate == today) {
      // Today: show time with AM/PM
      return DateFormat('h:mm a').format(dateTime);
    } else if (mailDate == yesterday) {
      // Yesterday
      return 'Yesterday';
    } else if (dateTime.year == now.year) {
      // This year but not today/yesterday: show month and date
      return DateFormat('MMM d').format(dateTime);
    } else {
      // Past year: show month, date, and year
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grey = Colors.grey.shade400;
    final systemTheme = MediaQuery.of(context).platformBrightness;

    return BlocBuilder<MailBloc, MailState>(
      builder: (context, mailState) {
        // Find the updated mail from the bloc state
        MailModel? currentMail = widget.mail;
        if (widget.mail != null) {
          currentMail = mailState.inbox.firstWhere(
            (m) => m.id == widget.mail!.id,
            orElse: () => widget.mail!,
          );
        }

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
                onPressed: () {
                  final mailToDelete = currentMail ?? widget.mail;
                  if (mailToDelete != null) {
                    context.read<MailBloc>().add(
                      DeleteMailEvent(mailToDelete.id),
                    );
                    Navigator.pop(context);
                  }
                },
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  currentMail?.subject ??
                      widget.mail?.subject ??
                      "Annual reminder about Google Play terms and policies",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
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
                        ((currentMail?.from ?? widget.mail?.from ?? "G").split(
                              '@',
                            )[0])[0]
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  (currentMail?.from ??
                                          widget.mail?.from ??
                                          "Google Play")
                                      .split('@')[0],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                (currentMail?.timestamp ??
                                            widget.mail?.timestamp) !=
                                        null
                                    ? _formatTime(
                                      (currentMail?.timestamp ??
                                          widget.mail!.timestamp),
                                    )
                                    : "9:39 AM",
                                style: TextStyle(color: grey, fontSize: 13),
                              ),
                            ],
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

                    const SizedBox(width: 10),

                    IconButton(
                      icon: Icon(
                        (currentMail?.starred ?? false)
                            ? Icons.star
                            : Icons.star_border,
                        size: 26,
                      ),
                      onPressed: () {
                        if (currentMail != null) {
                          final newStarredValue = !currentMail.starred;
                          context.read<MailBloc>().add(
                            ToggleStarEvent(currentMail.id, newStarredValue),
                          );
                        }
                      },
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
                        _infoRow(
                          "From",
                          currentMail?.from ??
                              widget.mail?.from ??
                              "no-reply@google.com",
                        ),
                        const SizedBox(height: 6),
                        _infoRow(
                          "To",
                          currentMail?.to ?? widget.mail?.to ?? "me",
                        ),
                        const SizedBox(height: 6),
                        _infoRow(
                          "Date",
                          (currentMail?.timestamp ?? widget.mail?.timestamp) !=
                                  null
                              ? DateFormat('MMM d, y h:mm a').format(
                                (currentMail?.timestamp ??
                                    widget.mail!.timestamp),
                              )
                              : "${DateTime.now().toLocal()}",
                        ),
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
                    currentMail?.body ??
                        widget.mail?.body ??
                        "This is sample email content for UI.\n\nReplace with real mail body.",
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
      },
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
