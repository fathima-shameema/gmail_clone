import 'package:flutter/material.dart';

class InboxList extends StatelessWidget {
  const InboxList({super.key});

  @override
  Widget build(BuildContext context) {
    final systemTheme = MediaQuery.of(context).platformBrightness;

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
        itemCount: 18,
        separatorBuilder: (c, i) => SizedBox(height: 5),
        itemBuilder: (context, index) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.vertical(
                top: Radius.circular(index == 0 ? 25 : 0),
                bottom: Radius.circular(index == 17 ? 25 : 0),
              ),
            ),
            tileColor:
                systemTheme == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.grey[100],
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade400,
              child: Text("S"),
            ),
            title: Text(
              "Sender Name $index",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "This is a sample email preview for UI only.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("11:45 AM"),
                SizedBox(height: 5),
                Icon(Icons.star_border, size: 22),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/Mail details');
            },
          );
        },
      ),
    );
  }
}
