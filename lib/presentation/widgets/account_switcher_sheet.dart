import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/user_account.dart';

class AccountSwitcherPanel extends StatefulWidget {
  const AccountSwitcherPanel({super.key});

  @override
  State<AccountSwitcherPanel> createState() => _AccountSwitcherPanelState();
}

class _AccountSwitcherPanelState extends State<AccountSwitcherPanel>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final accounts = state.accounts;
    final active = state.activeUser;
    final systemTheme = MediaQuery.of(context).platformBrightness;

    final otherAccounts = accounts.where((u) => u.uid != active?.uid).toList();

    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    active?.email ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 35),
                  IconButton(
                    icon: const Icon(Icons.close, size: 23),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              CircleAvatar(
                radius: 55,
                backgroundImage:
                    active?.photo != null ? NetworkImage(active!.photo!) : null,
                child:
                    active?.photo == null
                        ? Text(
                          (active?.email[0] ?? "?").toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),

              const SizedBox(height: 20),

              Text(
                "Hi ${active?.name ?? ""}!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                decoration: BoxDecoration(
                  color:
                      systemTheme == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => expanded = !expanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Switch account",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AnimatedRotation(
                            turns: expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child:
                          expanded
                              ? Column(
                                children: [
                                  if (otherAccounts.isNotEmpty)
                                    ...otherAccounts.map(_accountTile),
                                  ListTile(
                                    leading: const Icon(Icons.add, size: 23),
                                    title: const Text("Add another account"),
                                    onTap: () {
                                      context.read<AuthBloc>().add(
                                        SignInWithGoogle(),
                                      );
                                    },
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Text(
                "Privacy Policy  •  Terms of Service",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountTile(AppUser user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.photo != null ? NetworkImage(user.photo!) : null,
        child:
            user.photo == null
                ? Text(
                  user.email[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                )
                : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      onTap: () {
        context.read<AuthBloc>().add(SwitchAccount(user));
        context.read<MailBloc>().add(ResetMailStateEvent()); // ⭐ NEW
        context.read<MailBloc>().add(LoadInboxEvent(user.email, user.uid)); // ⭐ NEW
        Navigator.pop(context);
      },
    );
  }
}
