import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auckland_feb20/bloc.dart';
import 'package:flutter_auckland_feb20/boxes_array_widget.dart';
import 'package:flutter_auckland_feb20/sliders.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'WidgetKeys.dart';
import 'WidgetKeys.dart';
import 'animated_box.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auckland Meetup Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      routes: {
        '/web': (_) => WebviewScaffold(
              url: "https://flutter.dev",
              appBar: new AppBar(
                title: const Text('Widget Webview'),
              ),
            )
      },
      home: BlocProvider<SliderBloc>(
        creator: (_context, _bag) {
          return SliderBloc();
        },
        child: MyHomePage(title: 'Flutter Auckland Meetup Demo'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SliderBloc>(context);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CollectorWatcher(),
          AutoSizeText(
            'Slider sample app',
            style: Theme.of(context).textTheme.display1,
          ),
          RaisedButton(
            key: ValueKey(WidgetKeys.tapHereButton),
            onPressed: () {
              _showDialog(context);
            },
            child: Text("Tap here"),
          ),
          RaisedButton(
            key: ValueKey(WidgetKeys.webButton),
            onPressed: () {
              _opennewpage(context);
            },
            child: Text("Open webview"),
          ),
          SliderWidget(
            initialValue: bloc.slider1Value,
            valueChanged: (v) => bloc.addSliderValueToStream(v),
            key: ValueKey(WidgetKeys.slider),
          ),
          AutoSizeText('Slider2'),
          SliderWidget(
            initialValue: bloc.slider2Value,
            valueChanged: (v) => bloc.addSlider2(v),
            key: ValueKey(WidgetKeys.slider2),
          ),
          BoxesArrayWidget()
        ],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CollectorWatcher extends StatefulWidget {
  @override
  _CollectorWatcherState createState() => _CollectorWatcherState();
}

class _CollectorWatcherState extends State<CollectorWatcher> {
  int jackpot = jackpotFunc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: BlocProvider.of<SliderBloc>(context).combined,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is double) {
          if (snapshot.data.toInt() == jackpot) {
            Widget w = AutoSizeText(
              'You hit the jackpot of $jackpot!',
              style: TextStyle(fontSize: 26.0),
              textKey: ValueKey(WidgetKeys.jackpotMessage),
            );
            jackpot = jackpotFunc();
            return w;
          }
        }

        return SizedBox.shrink();
      },
    );
  }
}

Future<void> _showDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        key: ValueKey(WidgetKeys.infodialog),
        title: Text(
          'This is an AlerDialog',
          key: ValueKey(WidgetKeys.dialogText),
        ),
        content: AnimatedBox(),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _opennewpage(BuildContext context) {
  Navigator.of(context).pushNamed('/web');
}

typedef int JackpotFunc();

JackpotFunc jackpotFunc = () => Random().nextInt(20);
