import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/search_bloc/search_bloc.dart';
import 'package:gmail_clone/presentation/screens/home/search_page.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({
    super.key,
    required this.systemTheme,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final Brightness systemTheme;
  final TextEditingController _searchController;
  @override
  Size get preferredSize => Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          onChanged: (v) {
            context.read<SearchBloc>().add(SearchQueryChanged(v));
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: context.read<SearchBloc>(), // pass existing bloc
                      child: const SearchPage(),
                    ),
              ),
            );
          },
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
    );
  }
}
