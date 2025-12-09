import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';

class MailTile extends StatelessWidget {
  final int index;
  final List<MailModel> allMails;
  final Brightness systemTheme;
  final bool isSent;
  final Function(String) getInitials;
  final String displayEmail;
  final MailModel mail;
  final Function(DateTime) formatTime;
  final String displayName;
  const MailTile({
    super.key,
    required this.index,
    required this.systemTheme,
    required this.isSent,
    required this.getInitials,
    required this.displayEmail,
    required this.mail,
    required this.formatTime,
    required this.displayName,
    required this.allMails,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(index == 0 ? 25 : 0),
          bottom: Radius.circular(index == allMails.length - 1 ? 25 : 0),
        ),
      ),
      tileColor:
          systemTheme == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
      leading: CircleAvatar(
        backgroundColor: isSent ? Colors.blue.shade400 : Colors.red.shade400,
        child: Text(
          getInitials(displayName),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              isSent ? 'To:$displayEmail' : displayEmail,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSent)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(Icons.send, size: 16, color: Colors.grey[600]),
            ),
        ],
      ),
      subtitle: Text(
        mail.subject.isEmpty ? "(No subject)" : mail.subject,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatTime(mail.timestamp),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 5),
          mail.isDeleted
              ? SizedBox.shrink()
              : GestureDetector(
                onTap: () {
                  context.read<MailBloc>().add(
                    ToggleStarEvent(mail.id, !mail.starred),
                  );
                },
                child: Icon(
                  mail.starred ? Icons.star : Icons.star_border,
                  size: 22,
                ),
              ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/Mail details',
          arguments: {
            "mail": mail,
            "isSent": isSent, 
          },
        );
      },
    );
  }
}
