import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/presentation/widgets/drawer_item.dart';

class GmailDrawer extends StatelessWidget {
  const GmailDrawer({super.key});

  void _handleDrawerItemTap(
    BuildContext context,
    DrawerFilterType filterType,
  ) {
    final mailBloc = context.read<MailBloc>();
    final authState = context.read<AuthBloc>().state;
    
    // Set the filter type
    mailBloc.add(SetDrawerFilterEvent(filterType));
    
    // Load mails based on filter type
    switch (filterType) {
      case DrawerFilterType.allInboxes:
        final allEmails = authState.accounts.map((acc) => acc.email).toList();
        if (allEmails.isNotEmpty) {
          mailBloc.add(LoadAllInboxesEvent(allEmails));
          mailBloc.add(LoadAllSentEvent(allEmails));
        }
        break;
      case DrawerFilterType.primary:
        final activeUser = authState.activeUser;
        if (activeUser != null) {
          // Only load inbox mails (mails where to == activeUser.email)
          mailBloc.add(LoadInboxEvent(activeUser.email));
        }
        break;
      case DrawerFilterType.promotions:
      case DrawerFilterType.social:
        // Leave blank for now
        break;
      case DrawerFilterType.starred:
        // Load starred mails for active user
        final activeUser = authState.activeUser;
        if (activeUser != null) {
          mailBloc.add(LoadInboxEvent(activeUser.email));
        }
        break;
      case DrawerFilterType.important:
      case DrawerFilterType.sent:
      case DrawerFilterType.spam:
      case DrawerFilterType.bin:
        // Will be implemented later
        break;
    }
    
    // Close the drawer
    Navigator.of(context).pop();
  }

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
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.allInboxes,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
                        child: Text("Inbox", style: TextStyle(fontSize: 14)),
                      ),

                      DrawerItem(
                        icon: Icons.inbox,
                        label: "Primary",
                        highlight: currentFilter == DrawerFilterType.primary,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.primary,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.local_offer_outlined,
                        label: "Promotions",
                        highlight: currentFilter == DrawerFilterType.promotions,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.promotions,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.people_outline,
                        label: "Social",
                        highlight: currentFilter == DrawerFilterType.social,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.social,
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 0, 4),
                        child: Text("All labels", style: TextStyle(fontSize: 14)),
                      ),

                      DrawerItem(
                        icon: Icons.star_outline,
                        label: "Starred",
                        highlight: currentFilter == DrawerFilterType.starred,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.starred,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.label_important_outline,
                        label: "Important",
                        highlight: currentFilter == DrawerFilterType.important,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.important,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.send_outlined,
                        label: "Sent",
                        highlight: currentFilter == DrawerFilterType.sent,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.sent,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.report_gmailerrorred_outlined,
                        label: "Spam",
                        highlight: currentFilter == DrawerFilterType.spam,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.spam,
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.delete_outline,
                        label: "Bin",
                        highlight: currentFilter == DrawerFilterType.bin,
                        onTap: () => _handleDrawerItemTap(
                          context,
                          DrawerFilterType.bin,
                        ),
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
