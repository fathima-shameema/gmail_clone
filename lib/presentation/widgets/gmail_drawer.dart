import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/presentation/widgets/drawer_item.dart';

class GmailDrawer extends StatelessWidget {
  final Function(DrawerFilterType) onFilterSelected;

  const GmailDrawer({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MailBloc, MailState>(
      builder: (context, mailState) {
        final currentFilter = mailState.filterType;

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
                      DrawerItem(
                        icon: Icons.all_inbox,
                        label: "All inboxes",
                        highlight: currentFilter == DrawerFilterType.allInboxes,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.allInboxes);
                          Navigator.of(context).pop();
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
                        child: Text("Inbox", style: TextStyle(fontSize: 14)),
                      ),

                      DrawerItem(
                        icon: Icons.inbox,
                        label: "Primary",
                        highlight: currentFilter == DrawerFilterType.primary,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.primary);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.local_offer_outlined,
                        label: "Promotions",
                        highlight: currentFilter == DrawerFilterType.promotions,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.promotions);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.people_outline,
                        label: "Social",
                        highlight: currentFilter == DrawerFilterType.social,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.social);
                          Navigator.of(context).pop();
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 0, 4),
                        child: Text(
                          "All labels",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      DrawerItem(
                        icon: Icons.star_outline,
                        label: "Starred",
                        highlight: currentFilter == DrawerFilterType.starred,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.starred);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.label_important_outline,
                        label: "Important",
                        highlight: currentFilter == DrawerFilterType.important,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.important);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.send_outlined,
                        label: "Sent",
                        highlight: currentFilter == DrawerFilterType.sent,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.sent);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.report_gmailerrorred_outlined,
                        label: "Spam",
                        highlight: currentFilter == DrawerFilterType.spam,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.spam);
                          Navigator.of(context).pop();
                        },
                      ),
                      DrawerItem(
                        icon: Icons.delete_outline,
                        label: "Bin",
                        highlight: currentFilter == DrawerFilterType.bin,
                        onTap: () {
                          onFilterSelected(DrawerFilterType.bin);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
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
