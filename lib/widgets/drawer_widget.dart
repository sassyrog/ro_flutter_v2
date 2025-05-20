import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/data/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current route name
    final String currentRoute =
        ModalRoute.of(context)!.settings.name ?? '/home';

    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: Text(
                    KConstants.appName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 24,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  LucideIcons.home,
                  "Home",
                  '/home',
                  currentRoute,
                  null,
                ),
                _buildDrawerItem(
                  context,
                  LucideIcons.building,
                  "Business",
                  '/business',
                  currentRoute,
                  null,
                ),

                // _buildDrawerItem(
                //   context,
                //   Icons.school,
                //   "School",
                //   '/school',
                //   currentRoute,
                // ),
              ],
            ),
          ),
          buildDrawerBottomItem(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    String currentRoute,
    GestureTapCallback? onTap,
  ) {
    final isSelected = currentRoute == route;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        // size: 30.0,
        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          // fontSize: 24.0,
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.white,
      selectedTileColor: theme.colorScheme.primary,
      contentPadding: const EdgeInsets.fromLTRB(30.0, 5.0, 20.0, 5.0),
      enableFeedback: true,
      onTap:
          onTap ??
          () {
            // Close the drawer
            Navigator.pop(context);

            // Navigate to the new route if we're not already there
            if (currentRoute != route) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
    );
  }

  Widget buildDrawerBottomItem(BuildContext context, bool isDarkMode) {
    Color darkModeIconColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.2);

    void onDarkModeToggle() async {
      isDarkModeNotifier.value = !isDarkMode;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(KConstants.themeModeKey, !isDarkMode);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
      child: SizedBox(
        height: 72,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            isDarkMode
                ? IconButton(
                  onPressed: onDarkModeToggle,
                  icon: Icon(LucideIcons.sun),
                  style: IconButton.styleFrom(
                    backgroundColor: darkModeIconColor,
                    padding: EdgeInsets.zero,
                    iconSize: 40,
                  ),
                )
                : IconButton(
                  onPressed: onDarkModeToggle,
                  icon: Icon(
                    LucideIcons.moonStar,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: darkModeIconColor,
                    padding: EdgeInsets.zero,
                    iconSize: 40,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
