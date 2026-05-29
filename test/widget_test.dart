import 'package:flutter_test/flutter_test.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/auth/presentation/view/login_page.dart';
import 'package:nuigate/main.dart';
import 'package:nuigate/utils/pref_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PrefHelpers.init();
    await ServiceLocator.init();
  });

  testWidgets('shows login page when no saved session exists', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
