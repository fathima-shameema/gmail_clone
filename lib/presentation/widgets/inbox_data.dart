// lib/presentation/widgets/inbox_data.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/widgets/mail_tile.dart';

class InboxData extends StatelessWidget {
  final bool isBin;
  final bool isSent;
  final List<MailModel> allMails;
  final Brightness systemTheme;
  final Function(String) getInitials;
  final Function(DateTime) formatTime;
  final dynamic activeUser; // AppUser

  const InboxData({
    super.key,
    required this.isBin,
    required this.isSent,
    required this.allMails,
    required this.systemTheme,
    required this.getInitials,
    required this.formatTime,
    required this.activeUser,
  });

  @override
  Widget build(BuildContext context) {
    final uid = activeUser?.uid ?? '';

    return Expanded(
      child: Column(
        children: [
          if (isBin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.delete_outline, size: 30, color: Colors.lightBlueAccent),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Items that have been in bin for more than 30 days will be automatically deleted.',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.read<MailBloc>().add(EmptyBinEvent(uid));
                    },
                    child: Text('Empty Bin now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.lightBlueAccent)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
              itemCount: allMails.length,
              separatorBuilder: (c, i) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final mail = allMails[index];
                final sentFlag = activeUser != null && mail.from == (activeUser?.email ?? '');
                final displayName = sentFlag ? mail.to : mail.from;
                final displayEmail = displayName;
                return MailTile(
                  index: index,
                  systemTheme: systemTheme,
                  isSent: sentFlag,
                  getInitials: getInitials,
                  displayEmail: displayEmail,
                  mail: mail,
                  formatTime: formatTime,
                  displayName: displayName,
                  allMails: allMails,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
