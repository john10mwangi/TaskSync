import 'package:flutter_test/flutter_test.dart';
import 'package:task_sync/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TasksViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
