import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage('assets/images/img_cat.png'), // Your avatar image
            width: 100,  // Adjust width as needed
            height: 100, // Adjust height as needed
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'All',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '14',
                          style: TextStyle(fontSize: 48),
                        ),
                        Text(
                          '3177',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildScoreColumn('Listening', '7.0', Colors.blue),
                        _buildScoreColumn('Writing', '4.0', Colors.red),
                        _buildScoreColumn('Reading', '8.0', Colors.green),
                        _buildScoreColumn('Speaking', '6.5', Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 200.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    'Your chart goes here',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildScoreColumn(String title, String score, Color color) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: color),
        ),
        Text(
          score,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
