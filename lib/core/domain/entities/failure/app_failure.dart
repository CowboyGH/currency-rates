/// Ошибка, обработанная в слое бизнес-логики приложения.
///
/// Подразумевается, что это единственный вид ошибки, который мы можем получить
/// в презентационном слое приложения.
abstract class AppFailure implements Exception {
  /// Сообщение ошибки.
  final String? message;

  /// Родительское исключение ([Exception] или [Error]), если имеется.
  ///
  /// Сохраняется как [Object], чтобы покрывать все возможные типы.
  final Object? parentException;

  /// [StackTrace] родительской ошибки, если есть.
  final StackTrace? stackTrace;

  const AppFailure({this.message, this.parentException, this.stackTrace});
}
