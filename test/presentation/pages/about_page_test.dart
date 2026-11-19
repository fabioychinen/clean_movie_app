import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mostra o logo e os avisos de atribuição da TMDB', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text(CoreStrings.tmdbNotice), findsOneWidget);
    expect(find.text(CoreStrings.tmdbNoticeOriginal), findsOneWidget);
    expect(find.text(CoreStrings.justWatchAttribution), findsOneWidget);
  });
}