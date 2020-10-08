import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Web3 Demo')),
      body: buildContent(context),
    );
  }

  buildContent(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.all(22),
      width: double.infinity,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome...',
              style: theme.headline4,
            ),
            Text('Your ETH Address:'),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () => print('You clicked me!'),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Check Authorization'),
            ),
          ],
        ),
      ),
    );
  }
}
