import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/compose_bloc/compose_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/widgets/compose_appbar.dart';
import 'package:gmail_clone/presentation/widgets/compose_body.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen>
    with TickerProviderStateMixin {
  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController ccCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? sendingSnack;

  @override
  void dispose() {
    toCtrl.dispose();
    ccCtrl.dispose();
    subjectCtrl.dispose();
    bodyCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _sendMail(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final composeState = context.read<ComposeBloc>().state;
    final currentFrom =
        composeState.selectedFrom.isNotEmpty
            ? composeState.selectedFrom
            : (authState.activeUser?.email ?? "");

    if (currentFrom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a sender email")),
      );
      return;
    }

    final toEmail = toCtrl.text.trim();
    if (toEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipient email is required")),
      );
      return;
    }

    if (!_isValidEmail(toEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    final subject = subjectCtrl.text.trim();
    if (subject.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Subject is required")));
      return;
    }

    final body = bodyCtrl.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email body cannot be empty")),
      );
      return;
    }

    final ccEmail = ccCtrl.text.trim();
    if (ccEmail.isNotEmpty && !_isValidEmail(ccEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid CC email address")),
      );
      return;
    }

    final userUid = authState.activeUser?.uid ?? '';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final mailId = "${userUid}_$timestamp";

    final mail = MailModel(
      id: mailId,
      from: currentFrom,
      to: toEmail,
      cc: ccEmail.isEmpty ? null : ccEmail,
      subject: subject,
      body: body,
      timestamp: DateTime.now(),
      userStatus: {},
      userIds: [],
    );

    context.read<ComposeBloc>().add(StartSendingEvent());

    sendingSnack = ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Sending…")));

    context.read<MailBloc>().add(SendMailEvent(mail, userUid));
  }

  @override
  Widget build(BuildContext context) {
    final initialFrom = context.read<AuthBloc>().state.activeUser?.email ?? "";

    return BlocProvider(
      create: (_) => ComposeBloc(initialFrom: initialFrom),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState.activeUser != null) {
            final compose = context.read<ComposeBloc>();
            final currentSelected = compose.state.selectedFrom;
            final newDefault = authState.activeUser!.email;
            if (currentSelected.isEmpty || currentSelected == newDefault) {
              compose.add(SetSelectedFromEvent(newDefault));
            }
          }
        },
        child: BlocListener<MailBloc, MailState>(
          listener: (context, mailState) {
            final compose = context.read<ComposeBloc>();
            if (compose.state.isSending &&
                !mailState.loading &&
                mailState.error == null) {
              sendingSnack?.close();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Sent")));
              compose.add(StopSendingEvent());
              Navigator.pop(context);
            }

            if (mailState.error != null) {
              sendingSnack?.close();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${mailState.error}")),
              );
              compose.add(StopSendingEvent());
            }
          },
          child: Scaffold(
            appBar: ComposeAppbar(onSent: _sendMail),

            body: ComposeBody(
              toController: toCtrl,
              ccController: ccCtrl,
              subjectController: subjectCtrl,
              bodyController: bodyCtrl,
            ),
          ),
        ),
      ),
    );
  }
}
