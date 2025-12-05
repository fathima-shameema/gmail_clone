import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen>
    with TickerProviderStateMixin {
  bool expandFrom = false;
  bool expandTo = false;

  String selectedFrom = "";

  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController ccCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();

  final FocusNode bodyFocus = FocusNode();

  bool isSending = false;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? sendingSnack;

  InputDecoration noBorderDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      isDense: true,
    );
  }

  @override
  void dispose() {
    toCtrl.dispose();
    ccCtrl.dispose();
    subjectCtrl.dispose();
    bodyCtrl.dispose();
    bodyFocus.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _sendMail() {
    // Get current from email (fallback to active user if not set)
    final authState = context.read<AuthBloc>().state;
    final currentFrom = selectedFrom.isNotEmpty
        ? selectedFrom
        : (authState.activeUser?.email ?? "");

    // Validate "from" field
    if (currentFrom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a sender email")),
      );
      return;
    }

    // Validate "to" field
    final toEmail = toCtrl.text.trim();
    if (toEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipient email is required")),
      );
      return;
    }

    // Validate email format for "to" field
    if (!_isValidEmail(toEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    // Validate "subject" field
    final subject = subjectCtrl.text.trim();
    if (subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subject is required")),
      );
      return;
    }

    // Validate "body" field
    final body = bodyCtrl.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email body cannot be empty")),
      );
      return;
    }

    // Validate CC field if provided
    final ccEmail = ccCtrl.text.trim();
    if (ccEmail.isNotEmpty && !_isValidEmail(ccEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid CC email address")),
      );
      return;
    }

    // Generate unique mail ID using user's UID + timestamp
    final userUid = authState.activeUser?.uid ?? "";
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final mailId = userUid.isNotEmpty 
        ? "${userUid}_$timestamp"
        : "mail_$timestamp"; // Fallback if no UID available

    final mail = MailModel(
      id: mailId,
      from: currentFrom,
      to: toEmail,
      cc: ccEmail.isEmpty ? null : ccEmail,
      subject: subject,
      body: body,
      timestamp: DateTime.now(),
      isSent: true,
    );

    sendingSnack = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text("Sending…"),
          ],
        ),
        duration: const Duration(hours: 1), // until manually closed
      ),
    );

    setState(() => isSending = true);

    context.read<MailBloc>().add(SendMailEvent(mail));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState.activeUser != null &&
            (selectedFrom.isEmpty ||
                selectedFrom == authState.activeUser!.email)) {
          setState(() {
            selectedFrom = authState.activeUser!.email;
          });
        }
      },
      child: BlocListener<MailBloc, MailState>(
        listener: (context, state) {
          if (isSending && !state.loading && state.error == null) {
            // sending completed
            sendingSnack?.close();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Sent")));
            Navigator.pop(context);
          }

          if (state.error != null) {
            sendingSnack?.close();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
            setState(() => isSending = false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.4,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 23),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.attach_file, size: 23),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 23),
                onPressed: isSending ? null : _sendMail,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 23),
                onPressed: () {},
              ),
            ],
          ),

          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final activeUser = authState.activeUser;
              final allAccounts = authState.accounts;

              final otherAccounts =
                  allAccounts
                      .where((acc) => acc.uid != activeUser?.uid)
                      .toList();

              final currentFrom =
                  selectedFrom.isNotEmpty
                      ? selectedFrom
                      : (activeUser?.email ?? "");

              final showDropdown = otherAccounts.isNotEmpty;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap:
                        showDropdown
                            ? () => setState(() => expandFrom = !expandFrom)
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
                              turns: expandFrom ? 0.5 : 0,
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
                        expandFrom
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,

                    firstChild: Column(
                      children:
                          otherAccounts.map((acc) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFrom = acc.email;
                                  expandFrom = false;
                                });
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
                    onTap: () => setState(() => expandTo = !expandTo),
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
                              controller: toCtrl,
                              decoration: noBorderDecoration(""),
                            ),
                          ),
                          AnimatedRotation(
                            turns: expandTo ? 0.5 : 0,
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
                        expandTo
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    firstChild: Column(
                      children: [
                        _fieldRow("Cc", ccCtrl),
                        const Divider(height: 1),
                      ],
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),

                  _fieldRow("Subject", subjectCtrl),
                  const Divider(height: 1),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: bodyCtrl,
                        focusNode: bodyFocus,
                        maxLines: null,
                        expands: true,
                        decoration: noBorderDecoration(
                          bodyFocus.hasFocus || bodyCtrl.text.isNotEmpty
                              ? ""
                              : "Compose email",
                        ),
                        keyboardType: TextInputType.multiline,
                        onChanged: (_) => setState(() {}),
                        onTap: () => setState(() {}),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _fieldRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: noBorderDecoration(""),
            ),
          ),
        ],
      ),
    );
  }
}
