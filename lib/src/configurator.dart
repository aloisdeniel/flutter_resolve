import 'package:flutter/widgets.dart';
import 'package:resolve/src/utils.dart';

/// An empty configuration.
/// 
/// See also:
/// 
/// * [Provider] for a [Resolver] with no configuration.
abstract class NoConfiguration {}

/// The [Configurator] is an [InheritedWidget] that exposes
/// a global configuration for its descendants.
/// 
/// See also:
///
///  * [Resolver] for widget that can instantiate an instance
///    from of the current configuration.
@immutable
class Configurator<TConfiguration> extends InheritedWidget {
  Configurator({@required this.configuration, @required Widget child})
      : super(child: child);

  final TConfiguration configuration;

  static TConfiguration of<TConfiguration>(BuildContext context) {
    if(TConfiguration == NoConfiguration) {
      return null;
    }

    final type = typeOf<Configurator<TConfiguration>>();
    Configurator<TConfiguration> configurator =
        context.dependOnInheritedWidgetOfExactType(type);
    //  context.inheritFromWidgetOfExactType(type);
    // INFO: 'inheritFromWidgetOfExactType' is deprecated and shouldn't be used. 
    // Use dependOnInheritedWidgetOfExactType instead. This feature was deprecated after v1.12.1.
    assert(configurator != null, "you must add a $type in your widget tree");
    return configurator.configuration;
  }

  @override
  bool updateShouldNotify(Configurator<TConfiguration> oldWidget) =>
      this.configuration != oldWidget.configuration;
}
