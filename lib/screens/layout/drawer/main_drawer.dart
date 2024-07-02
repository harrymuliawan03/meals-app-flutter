import 'package:flutter/material.dart';
import 'package:meals_app/screens/login_screen.dart';
import 'package:meals_app/service/local_storage_service.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSetScreen});

  final void Function(String identifier) onSetScreen;

  @override
  Widget build(BuildContext context) {
    final role = LocalStorage.getStringData('role');

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Resepku !',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Home',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSetScreen('meal');
            },
          ),
          if (role == 'admin')
            ListTile(
              leading: Icon(
                Icons.restaurant,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Meals',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                onSetScreen('meals-control');
              },
            ),

          ListTile(
            leading: Icon(
              Icons.label,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Testing Riverpod',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSetScreen('testing-riverpod');
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.category,
          //     size: 26,
          //     color: Theme.of(context).colorScheme.onBackground,
          //   ),
          //   title: Text(
          //     'Categories',
          //     style: Theme.of(context).textTheme.titleSmall!.copyWith(
          //           color: Theme.of(context).colorScheme.onBackground,
          //           fontSize: 24,
          //         ),
          //   ),
          //   onTap: () {
          //     onSetScreen('meal');
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSetScreen('filters');
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              LocalStorage.removeAll();

              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
