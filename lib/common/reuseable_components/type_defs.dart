import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEithervoid = FutureEither<void>;

class Failure {
  final String text;
  Failure(this.text);
}
