import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/presentation/widgets/account_switcher_sheet.dart';
import 'package:gmail_clone/presentation/widgets/gmail_drawer.dart';
import 'package:gmail_clone/presentation/widgets/home_screen_appbar.dart';
import 'package:gmail_clone/presentation/widgets/inbox_list.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState.activeUser != null) {
        final mailBloc = context.read<MailBloc>();

        mailBloc.add(ResetMailStateEvent());
        mailBloc.add(SetDrawerFilterEvent(DrawerFilterType.primary));
        mailBloc.add(LoadInboxEvent(authState.activeUser!.email));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getFilterTitle(DrawerFilterType filterType) {
    switch (filterType) {
      case DrawerFilterType.allInboxes:
        return 'All inboxes';
      case DrawerFilterType.primary:
        return 'Primary';
      case DrawerFilterType.promotions:
        return 'Promotions';
      case DrawerFilterType.social:
        return 'Social';
      case DrawerFilterType.starred:
        return 'Starred';
      case DrawerFilterType.important:
        return 'Important';
      case DrawerFilterType.sent:
        return 'Sent';
      case DrawerFilterType.spam:
        return 'Spam';
      case DrawerFilterType.bin:
        return 'Bin';
    }
  }

  void _handleDrawerSelection(DrawerFilterType filterType) {
    final mailBloc = context.read<MailBloc>();
    final authState = context.read<AuthBloc>().state;
    final activeUser = authState.activeUser;

    mailBloc.add(SetDrawerFilterEvent(filterType));
    if (activeUser != null) {
      switch (filterType) {
        case DrawerFilterType.primary:
          mailBloc.add(LoadInboxEvent(activeUser.email));
          break;

        case DrawerFilterType.allInboxes:
          final emails = authState.accounts.map((e) => e.email).toList();
          mailBloc.add(LoadAllInboxesEvent(emails));
          break;

        case DrawerFilterType.starred:
          final activeUser = authState.activeUser;
          if (activeUser != null) {
            mailBloc.add(LoadInboxEvent(activeUser.email));
            mailBloc.add(LoadSentEvent(activeUser.email));
          }
          break;

        case DrawerFilterType.important:
          mailBloc.add(LoadImportantEvent(activeUser.email));
          break;

        case DrawerFilterType.sent:
          final activeUser = authState.activeUser;
          if (activeUser != null) {
            mailBloc.add(LoadSentEvent(activeUser.email));
          }
          break;

        case DrawerFilterType.spam:
          mailBloc.add(LoadInboxEvent(activeUser.email));
          break;

        case DrawerFilterType.bin:
          mailBloc.add(AutoCleanBinEvent(activeUser.email));
          mailBloc.add(LoadBinEvent(activeUser.email));
          break;

        case DrawerFilterType.promotions:
        case DrawerFilterType.social:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final systemTheme = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      drawer: GmailDrawer(onFilterSelected: _handleDrawerSelection),

      endDrawer: const AccountSwitcherPanel(),

      appBar: HomeScreenAppBar(
        systemTheme: systemTheme,
        searchController: _searchController,
      ),

      body: BlocBuilder<MailBloc, MailState>(
        builder: (context, mailState) {
          final title = _getFilterTitle(mailState.filterType);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        systemTheme == Brightness.dark
                            ? AppColors.liightGrey
                            : AppColors.darkgGey,
                  ),
                ),
              ),
              const InboxList(),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 18, 33, 163),
        elevation: 2,
        label: const Row(
          children: [
            Icon(Icons.edit_outlined, size: 22, color: Colors.white),
            SizedBox(width: 8),
            Text("Compose", style: TextStyle(color: Colors.white)),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/Compose mail');
        },
      ),

      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight,
        color:
            systemTheme == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade100,
      ),
    );
  }
}
