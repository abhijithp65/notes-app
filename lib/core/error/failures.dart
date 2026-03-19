abstract class AppFailure {
  final String message;
  const AppFailure(this.message);
  @override
  String toString() => message;
}

class DatabaseFailure  extends AppFailure { const DatabaseFailure(super.message); }
class ValidationFailure extends AppFailure { const ValidationFailure(super.message); }
class NotFoundFailure  extends AppFailure { const NotFoundFailure(super.message); }
