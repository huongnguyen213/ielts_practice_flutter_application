import 'package:flutter/material.dart';
import 'package:ielts_practice_flutter_application/page/layout/schedule_remider.dart';

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });

  String headerText;
  String expandedText;
  bool isExpanded;
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isReminderEnabled = false;

  final List<Item> _data = List<Item>.generate(
    3,
        (int index) {
      return Item(
        headerText: index == 0 ? 'Score' : index == 1 ? 'Learning Time' : 'Setting & Personal Information',
        expandedText: 'This is item number $index',
        isExpanded: false,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Image.asset("assets/images/img_cat.png"),
              ),
              const SizedBox(height: 16),
              const Text(
                'Minh Quan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ExpansionPanelList(
                elevation: 2,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !(_data[index].isExpanded);
                  });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(item.headerText),
                      );
                    },
                    body: item.headerText == 'Score'
                        ? _buildScorePanel()
                        : item.headerText == 'Learning Time'
                        ? _buildTimeStatsPanel()
                        : _buildSettingPanel(),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScorePanel() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatRow('Overall', '9.0', 'icons/icons8-test-48.png'),
            const Divider(),
            _buildStatRow('Listening', '9.0', 'icons/icons8-headphone-48.png'),
            const Divider(),
            _buildStatRow('Reading', '9.0', 'icons/icons8-book-48.png'),
            const Divider(),
            _buildStatRow('Writing', '9.0', 'icons/icons8-pencil-48.png'),
            const Divider(),
            _buildStatRow('Speaking', '9.0', 'icons/icons8-mic-48.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeStatsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Text('Time statistics will go here (e.g., charts)'),
    );
  }

  Widget _buildSettingPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          ListTile(
            title: const Text('Schedule Reminder'),
            trailing: Switch(
              value: _isReminderEnabled,
              onChanged: (value) {
                setState(() {
                  _isReminderEnabled = value;
                  if (_isReminderEnabled) {
                    _showReminderDialog(context);
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Personal Information'),
            onTap: () {
              // Navigate to personal information settings
            },
          ),
        ],
      ),
    );
  }

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to set up a study reminder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showTimeSetupDialog(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isReminderEnabled = false; // Reset switch if "No" is pressed
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showTimeSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set up study reminder'),
          content: const Text('Please set up the time for your study reminder.'), // Update content
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleReminderPage(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  // Widget _buildSettingPanel() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Column(
  //       children: [
  //         ListTile(
  //           title: const Text('Schedule Reminder'),
  //           trailing: Switch(
  //             value: _isReminderEnabled,
  //             onChanged: (value) {
  //               setState(() {
  //                 _isReminderEnabled = value;
  //                 if (_isReminderEnabled) {
  //                   _showReminderDialog(context);
  //                 }else{
  //                 }
  //               });
  //             },
  //           ),
  //         ),
  //         ListTile(
  //           title: const Text('Personal Information'),
  //           onTap: () {
  //             // Navigate to personal information settings
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatRow(String label, String time, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(iconPath, width: 40, height: 40),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
      ],
    );
  }

  // void _showReminderDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Do you want to set up a study reminder?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _showTimeSetupDialog(context);
  //             },
  //             child: const Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('No'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void _showTimeSetupDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Set up time'),
  //         content: const Text('You can set up the time here.'), // Add specific content if necessary
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
