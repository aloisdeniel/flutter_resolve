import 'package:flutter/material.dart';
import 'package:resolve/resolve.dart';
import 'package:example/service.dart';

void main() => runApp(
    Bootstrapper(configuration: Configuration.production, child: MyApp()));

enum Configuration {
  development,
  production,
}

class Bootstrapper extends StatelessWidget {
  Bootstrapper({@required this.configuration, this.child});

  final Configuration configuration;

  final Widget child;

  static Color _createColor(BuildContext context, Configuration config) =>
      (config == Configuration.development ? Colors.red : Colors.blue);

  static CatFactService _createService(
          BuildContext context, Configuration config) =>
      (config == Configuration.development
          ? MockCatFactService()
          : OnlineCatFactService());

  @override
  Widget build(BuildContext context) {
    return Configurator<Configuration>(
        configuration: this.configuration,
        child: Resolver<Color, Configuration>(
            creator: _createColor,
            child: Resolver<CatFactService, Configuration>(
                creator: _createService, child: child)));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resolver Demo',
      theme: ThemeData(
        primarySwatch: Resolver.of<Color>(context),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Fact> facts = [];
  String status = "not loaded";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    final service = Resolver.of<CatFactService>(this.context);
    this.setState(() => this.status = "loading ....");
    try {
      final newFacts = await service.getRandom();
      this.setState(() {
        this.facts = newFacts;
        this.status = "loaded";
      });
    } catch (e) {
      this.setState(() => this.status = "error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resolver example | ' + Configurator.of<Configuration>(context).toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.status,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: this.facts.length,
            itemBuilder: (c, i) => Padding(
                padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: Text(
                  this.facts[i].text,
                  style: Theme.of(context).textTheme.display1,
                )),
          ))
        ],
      ),
    );
  }
}
