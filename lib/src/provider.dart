import 'package:flutter/widgets.dart';
import 'package:resolve/resolve.dart';

/// A function that instanciates a [T] from a given
/// [context].
typedef T Creator<T>(BuildContext context);

/// A provider is a [Resolver] that hasn't any configuration.
class Provider<T> extends StatelessWidget {
  Provider({@required this.child, @required this.creator, this.disposer});

  /// The widget below this widget in the tree.
  final Widget child;

  /// The [creator] is the function that is used to create
  /// a [T] instance.
  final Creator<T> creator;

  /// A [disposer] can be precised to dispose the [T] instance when
  /// the resolver's state is disposed.
  final Disposer<T> disposer;

  @override
  Widget build(BuildContext context) {
    return Resolver<T, NoConfiguration>(
      child: this.child,
      creator: (b, c) => this.creator(b),
      disposer: this.disposer,
    );
  }
}
