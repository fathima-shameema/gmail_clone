import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/presentation/widgets/account_switcher_sheet.dart';
import 'package:gmail_clone/presentation/widgets/gmail_drawer.dart';
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
        context.read<MailBloc>().add(
          LoadInboxEvent(authState.activeUser!.email),
        );
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

    // 1. Update filter
    mailBloc.add(SetDrawerFilterEvent(filterType));

    // 2. Load required mailbox
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
        case DrawerFilterType.important:
        case DrawerFilterType.sent:
        case DrawerFilterType.spam:
          mailBloc.add(LoadInboxEvent(activeUser.email));
          break;

        case DrawerFilterType.bin:
          mailBloc.add(LoadBinEvent(activeUser.email));
          break;

        case DrawerFilterType.promotions:
        case DrawerFilterType.social:
          // planned later
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

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(size: 23),
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color:
                systemTheme == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(35),
          ),
          child: TextField(
            controller: _searchController,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              hint: Text(
                textAlign: TextAlign.center,
                "Search in mail",
                style: TextStyle(fontSize: 18),
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              final activeUser = context.watch<AuthBloc>().state.activeUser;

              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      activeUser?.photo != null
                          ? NetworkImage(activeUser!.photo!)
                          : null,
                  child:
                      activeUser?.photo == null
                          ? Text(
                            (activeUser?.email[0] ?? "?").toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          )
                          : null,
                ),
              );
            },
          ),
        ],
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
