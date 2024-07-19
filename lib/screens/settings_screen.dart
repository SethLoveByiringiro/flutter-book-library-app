import 'package:book_library_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Column(
            children: [
              ListTile(
                title: Text('Sorting Criteria'),
                trailing: DropdownButton<String>(
                  value: appState.sortingCriteria,
                  onChanged: (value) {
                    if (value != null) {
                      appState.updateSortingCriteria(value);
                    }
                  },
                  items: ['title', 'author', 'rating']
                      .map((criteria) => DropdownMenuItem(
                            value: criteria,
                            child: Text(criteria),
                          ))
                      .toList(),
                ),
              ),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: appState.isDarkMode,
                onChanged: (value) {
                  appState.toggleThemeMode();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
