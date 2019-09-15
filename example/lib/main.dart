import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shimmer',
      routes: {
        'loading': (_) => LoadingListPage(),
        'slide': (_) => SlideToUnlockPage(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shimmer'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Loading List'),
            onTap: () => Navigator.of(context).pushNamed('loading'),
          ),
          ListTile(
            title: Text('Slide To Unlock'),
            onTap: () => Navigator.of(context).pushNamed('slide'),
          ),
        ],
      ),
    );
  }
}

class LoadingListPage extends StatefulWidget {
  @override
  _LoadingListPageState createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingListPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading List'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: _enabled,
              child: Column(
                children: [0, 1, 2, 3, 4, 5, 6]
                    .map((_) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                    ),
                                    Container(
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _enabled = !_enabled;
                    });
                  },
                  child: Text(
                    _enabled ? 'Stop' : 'Play',
                    style: Theme.of(context).textTheme.button.copyWith(
                        fontSize: 18.0,
                        color: _enabled ? Colors.redAccent : Colors.green),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class SlideToUnlockPage extends StatelessWidget {
  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    final hour = time.hour;
    final minute = time.minute;
    final day = time.weekday;
    final month = time.month;
    final dayInMonth = time.day;
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide To Unlock'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 48.0,
            right: 0.0,
            left: 0.0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    '${hour < 10 ? '0$hour' : '$hour'}:${minute < 10 ? '0$minute' : '$minute'}',
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                  ),
                  Text(
                    '${days[day - 1]}, ${months[month - 1]} $dayInMonth',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 24.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Opacity(
                  opacity: 0.8,
                  child: Shimmer.fromColors(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/chevron_right.png',
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        ),
                        Text(
                          'Slide to unlock',
                          style: TextStyle(
                            fontSize: 28.0,
                          ),
                        )
                      ],
                    ),
                    baseColor: Colors.black12,
                    highlightColor: Colors.white,
                    loop: 3,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
