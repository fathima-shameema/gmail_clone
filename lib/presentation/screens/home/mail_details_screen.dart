import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/widgets/mail_details_appbar.dart';
import 'package:gmail_clone/presentation/widgets/mail_details_header.dart';
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
      return DateFormat('h:mm a').format(dateTime);
    } else if (mailDate == yesterday) {
      return 'Yesterday';
    } else if (dateTime.year == now.year) {
      return DateFormat('MMM d').format(dateTime);
    } else {
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
        MailModel? currentMail = widget.mail;
        if (widget.mail != null) {
          currentMail = mailState.inbox.firstWhere(
            (m) => m.id == widget.mail!.id,
            orElse: () => widget.mail!,
          );
        }

        return Scaffold(
          appBar: MailDetailsAppBar(currentMail: currentMail, widget: widget),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  currentMail?.subject ?? widget.mail?.subject ?? '',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              MailDetailsHeader(
                currentMail: currentMail,
                formatTime: _formatTime,
                grey: grey,
                mail: widget.mail,
                systemTheme: systemTheme,
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

 
}
