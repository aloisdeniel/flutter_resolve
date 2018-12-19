# Resolve

Managing dependencies with simple Widgets.

Features:

* Inversion of control, you define how to instantiate objects from outside
* Really integrated with the Flutter widget composability approach
* Scoped resolution since `Resolvers` and `Configurators` can be overriden wherever in the tree
* Generic widgets so you can use the configuration and instances you want

## Examples

* [Service from configuration](./example)

## Quickstart

#### Provider

```dart
class Bootstrapper extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Provider<String>(
            creator: (context) => "Hello world!",
            child: HomePage());
    }
}

class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final label = Resolver.of<String>(context);
        return Text(label);
    }
}
```

#### Resolver

```dart
enum Configuration {
  development,
  production,
}

class Bootstrapper extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Configurator<Configuration>(
            configuration: Configuration.production,
            child: Resolver<String, Configuration>(
            creator: ((context,config) => config == Configuration.development ? "Debug now" : "Online"),
            child: HomePage());
    }
}

class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        final label = Resolver.of<String>(context);
        return Text(label);
    }
}
```

## FAQ

> Can I use it with the *BLoC pattern* ?

Absolutely, I created it first for it, but wanted a more generic approach combined with dependency configuration. The solution is just an extended part of a typical bloc provider. 

**Don't forget to add a `disposer` for your blocs when registering them into the `Resolver` to close all exposed streams!**

> What if I have a pure Dart project ?

You can still use [dioc](https://github.io/aloisdeniel/dioc) which is a more traditionnal approach to inversion of control.

