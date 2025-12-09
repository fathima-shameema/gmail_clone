// lib/presentation/widgets/mail_details_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:intl/intl.dart';

class MailDetailsHeader extends StatelessWidget {
  final MailModel? currentMail;
  final Function(DateTime) formatTime;
  final Color grey;
  final MailModel? mail;
  final Brightness systemTheme;
  final bool isSent;

  const MailDetailsHeader({
    super.key,
    required this.currentMail,
    required this.formatTime,
    required this.grey,
    this.mail,
    required this.systemTheme,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    final mailData = currentMail ?? mail!;
    final uid = context.read<AuthBloc>().state.activeUser?.uid ?? '';
    final isExpanded = context.select<MailBloc, bool>((bloc) => bloc.state.expandedMailInfoIds.contains(mailData.id));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  (mailData.from.split('@')[0][0]).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
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
                            mailData.from.split('@')[0],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(formatTime(mailData.timestamp), style: TextStyle(color: grey, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        context.read<MailBloc>().add(ToggleMailInfoEvent(mailData.id));
                      },
                      child: Row(
                        children: [
                          Text(isSent ? 'to ${mailData.to.split('@')[0]}' : 'to me', style: TextStyle(fontSize: 14, color: grey)),
                          const SizedBox(width: 4),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              mailData.isDeleted(uid)
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: Icon(mailData.isStarred(uid) ? Icons.star : Icons.star_border, size: 26),
                      onPressed: () {
                        context.read<MailBloc>().add(ToggleStarEvent(mailData.id, uid, !mailData.isStarred(uid)));
                      },
                    ),
            ],
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: systemTheme == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("From", mailData.from),
                  const SizedBox(height: 6),
                  _infoRow("To", mailData.to),
                  const SizedBox(height: 6),
                  _infoRow("Date", DateFormat('MMM d, y h:mm a').format(mailData.timestamp)),
                ],
              ),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    );
  }
}
