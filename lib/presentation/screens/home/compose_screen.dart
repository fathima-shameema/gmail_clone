import 'package:flutter/material.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen>
    with TickerProviderStateMixin {
  bool expandFrom = false;
  bool expandTo = false;

  final List<String> accounts = [
    "fathimashameema116@gmail.com",
    "hafsathponneth@gmail.com",
    "fleetgo.rides@gmail.com",
  ];

  String selectedFrom = "fathimashameema116@gmail.com";

  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController ccCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();

  final FocusNode bodyFocus = FocusNode();

  InputDecoration noBorderDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      isDense: true,
    );
  }

  @override
  void dispose() {
    bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 23),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => expandFrom = !expandFrom),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Text("From", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      selectedFrom,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),

                  AnimatedRotation(
                    turns: expandFrom ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down, size: 22),
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
                  accounts.map((email) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedFrom = email;
                          expandFrom = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(32, 10, 16, 10),
                        alignment: Alignment.centerLeft,
                        child: Text(email),
                      ),
                    );
                  }).toList(),
            ),
            secondChild: const SizedBox.shrink(),
          ),

          _divider(),

          InkWell(
            onTap: () => setState(() => expandTo = !expandTo),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Text("To", style: Theme.of(context).textTheme.titleMedium),
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
                    child: const Icon(Icons.keyboard_arrow_down, size: 22),
                  ),
                ],
              ),
            ),
          ),

          _divider(),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                expandTo ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(children: [_fieldRow("Cc", ccCtrl), _divider()]),
            secondChild: const SizedBox.shrink(),
          ),

          _fieldRow("Subject", subjectCtrl),
          _divider(),

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

  Widget _divider() {
    return const Divider(thickness: 1, height: 1);
  }
}
