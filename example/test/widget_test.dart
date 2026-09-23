import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/main.dart';

void main() {
  testWidgets('Mint SDK demo screen shows all actions', (tester) async {
    await tester.pumpWidget(const MintDemoApp());

    expect(find.text('Mint SDK Demo'), findsWidgets);
    expect(find.text('Testing mode'), findsOneWidget);
    expect(find.text('Open Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Invoke SDK With SSO'), findsOneWidget);
    expect(find.text('Build Mint Screen'), findsOneWidget);
    expect(find.text('Clear SDK Data'), findsOneWidget);
  });
}
