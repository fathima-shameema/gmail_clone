import 'package:flutter/material.dart';
import 'package:gmail_clone/data/models/mail.dart';

class SearchResultTile extends StatelessWidget {
  final MailModel mail;
  final String query;

  const SearchResultTile({super.key, required this.mail, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(mail.from[0].toUpperCase())),
      title: _highlight(mail.subject, query),
      subtitle: _highlight(mail.body, query),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/Mail details',
          arguments: {
            "mail": mail,
            "isSent": mail.from == mail.to ? true : false, 
          },
        );
      },
    );
  }

  Widget _highlight(String text, String query) {
    if (query.isEmpty) return Text(text);

    final lower = text.toLowerCase();
    final qLower = query.toLowerCase();

    final index = lower.indexOf(qLower);
    if (index == -1) return Text(text);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: const TextStyle(
              backgroundColor: Colors.yellow,
              color: Colors.black,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}
