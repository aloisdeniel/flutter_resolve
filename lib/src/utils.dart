/// A workaround for resolving generic types
/// before wider adoption of Dart 2.1.0.
Type typeOf<T>() => T;