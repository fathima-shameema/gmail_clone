import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/compose_bloc/compose_bloc.dart';
import 'package:gmail_clone/presentation/widgets/field_row.dart';
import 'package:gmail_clone/presentation/widgets/no_border_input_decoration.dart';

class ComposeBody extends StatelessWidget {
  final TextEditingController toController;
  final TextEditingController ccController;
  final TextEditingController subjectController;
  final TextEditingController bodyController;
  const ComposeBody({
    super.key,
    required this.toController,
    required this.ccController,
    required this.subjectController,
    required this.bodyController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final activeUser = authState.activeUser;
        final allAccounts = authState.accounts;
        final otherAccounts =
            allAccounts.where((acc) => acc.uid != activeUser?.uid).toList();
        final showDropdown = otherAccounts.isNotEmpty;

        return BlocBuilder<ComposeBloc, ComposeState>(
          builder: (context, cstate) {
            final currentFrom =
                cstate.selectedFrom.isNotEmpty
                    ? cstate.selectedFrom
                    : (activeUser?.email ?? "");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap:
                      showDropdown
                          ? () => context.read<ComposeBloc>().add(
                            ToggleExpandFromEvent(),
                          )
                          : null,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Text(
                          "From",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            currentFrom,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (showDropdown)
                          AnimatedRotation(
                            turns: cstate.expandFrom ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState:
                      cstate.expandFrom
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  firstChild: Column(
                    children:
                        otherAccounts.map((acc) {
                          return InkWell(
                            onTap: () {
                              context.read<ComposeBloc>().add(
                                SetSelectedFromEvent(acc.email),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                32,
                                10,
                                16,
                                10,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage:
                                        acc.photo != null
                                            ? NetworkImage(acc.photo!)
                                            : null,
                                    child:
                                        acc.photo == null
                                            ? Text(
                                              acc.email[0].toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(acc.email),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                const Divider(height: 1),

                InkWell(
                  onTap:
                      () => context.read<ComposeBloc>().add(
                        ToggleExpandToEvent(),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        Text(
                          "To",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: toController,
                            decoration: noBorderDecoration(""),
                          ),
                        ),
                        AnimatedRotation(
                          turns: cstate.expandTo ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1),

                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState:
                      cstate.expandTo
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  firstChild: Column(
                    children: [
                      FieldRow(label: "Cc", controller: ccController),
                      const Divider(height: 1),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                FieldRow(label: "Subject", controller: subjectController),
                const Divider(height: 1),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: bodyController,
                      maxLines: null,
                      expands: true,
                      decoration: noBorderDecoration(
                        bodyController.text.isNotEmpty ? "" : "Compose email",
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
