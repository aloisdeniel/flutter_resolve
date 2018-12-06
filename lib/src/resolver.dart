import 'package:flutter/widgets.dart';
import 'package:resolve/src/configurator.dart';
import 'package:resolve/src/utils.dart';

/// A function that instanciates a [T] from a given
/// [context] and [configuration].
typedef T ConfiguredCreator<T, TConfiguration>(
    BuildContext context, TConfiguration configuration);

/// A function that disposes the given [instance].
/// 
/// For example, if [instances] has multiple [Stream]s, they 
/// must be closed.
typedef void Disposer<T>(T instance);

/// A resolver is a [Widget] that is responsible of giving access
/// to a  [T] instance to its [child] (and its descendant) from 
/// the current [TConfiguration] inherited from
/// a [Configurator<TConfiguration>].
/// 
/// A [disposer] can be precised if the instance created through
/// the [creator] must be disposed when the tree is unmounted.
/// 
/// See also:
///
///  * [Configurator] for widget that must be in the tree for
///    exposing a current configuration for resolvers.
class Resolver<T, TConfiguration> extends StatefulWidget {
  Resolver({
    Key key,
    this.disposer,
    @required this.creator,
    @required this.child,
  })  : assert(creator != null, "a creator must be provided"),
        super(key: key);

  /// The [creator] is the function that is used to create 
  /// a [T] instance from a given [TConfiguration].
  final ConfiguredCreator<T, TConfiguration> creator;

  /// A [disposer] can be precised to dispose the [T] instance when
  /// the resolver's state is disposed.
  final Disposer<T> disposer;

  /// The [child] is the descendant widget that will have
  /// access to the [T] instance.
  final Widget child;

  @override
  _ResolverState<T, TConfiguration> createState() =>
      _ResolverState<T, TConfiguration>();

  /// Get the [T] instance from the descendants of this 
  /// [Resolver].
  static T of<T>(BuildContext context) {
    final type = typeOf<_ResolverInherited<T>>();
    _ResolverInherited<T> resolver =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    assert(resolver != null, "no Resolver<$type> found in the widget tree");
    return resolver.instance;
  }
}

class _ResolverState<T, TConfiguration>
    extends State<Resolver<T, TConfiguration>> {
  T _instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._instance == null) {
      final configuration = Configurator.of<TConfiguration>(this.context);
      this._instance = this.widget.creator(this.context, configuration);
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.widget.disposer?.call(this._instance);
  }

  @override
  Widget build(BuildContext context) {
    print("build:" + this._instance?.toString());
    return _ResolverInherited<T>(
      instance: _instance,
      child: widget.child,
    );
  }
}

class _ResolverInherited<T> extends InheritedWidget {
  _ResolverInherited({
    Key key,
    @required Widget child,
    @required this.instance,
  }) : super(key: key, child: child);

  final T instance;

  @override
  bool updateShouldNotify(_ResolverInherited oldWidget) => false;
}
