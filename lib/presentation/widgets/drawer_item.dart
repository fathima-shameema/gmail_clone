import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.highlight = false,
  });
  final IconData icon;
  final String label;
  final bool highlight;
  @override
  Widget build(BuildContext context) {
    {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          decoration:
              highlight
                  ? BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: const Color.fromARGB(
                      255,
                      54,
                      108,
                      174,
                    ).withAlpha(150),
                  )
                  : null,
          child: ListTile(
            leading: Icon(icon, size: 23),
            title: Text(label),
            onTap: () {},
          ),
        ),
      );
    }
  }
}
