import 'package:flutter/material.dart';
import 'package:gmail_clone/presentation/widgets/drawer_item.dart';

class GmailDrawer extends StatelessWidget {
  const GmailDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Gmail",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(icon: Icons.all_inbox, label: "All inboxes"),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
                    child: Text("Inbox", style: TextStyle(fontSize: 14)),
                  ),

                  DrawerItem(
                    icon: Icons.inbox,
                    label: "Primary",
                    highlight: true,
                  ),
                  DrawerItem(
                    icon: Icons.local_offer_outlined,
                    label: "Promotions",
                  ),
                  DrawerItem(icon: Icons.people_outline, label: "Social"),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 4),
                    child: Text("All labels", style: TextStyle(fontSize: 14)),
                  ),

                  DrawerItem(icon: Icons.star_outline, label: "Starred"),
                  DrawerItem(
                    icon: Icons.label_important_outline,
                    label: "Important",
                  ),
                  DrawerItem(icon: Icons.send_outlined, label: "Sent"),
                  DrawerItem(
                    icon: Icons.report_gmailerrorred_outlined,
                    label: "Spam",
                  ),
                  DrawerItem(icon: Icons.delete_outline, label: "Bin"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
