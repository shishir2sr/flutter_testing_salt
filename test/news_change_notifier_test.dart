import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  // READ: Why late?
  //  Answer: Because we will initialize all of the objects in the setup method
  //  Setup Method Runs before each and every test

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);

    // READ: Why Moc Use korlo?
    // Karon real implementation e server er sathe communicate kora lagte pare
    // And data change hoite pare.
    // Amra check kormu data ashar pore thikmoto kaaj kortese kina eita
    // Then check kormu State gula thikmoto behave kortese kina eita
    // Ki data aitase, kotokhon time nitase, egula kintu check kormu na.
    // so real data er upor test korar dorkar ki? Jodi net na thake taile to
    // test function gula fail korbo. Ei karone amra moc data use kormu.
    // Moc data amra nijarar moto shajaite pari. Shob gula use case chinta korte pari
  });

  test(
    // READ: Ei Test method run hoibar aage setup method call hoibo
    // Eirokom prottekta test method run hoibar aage setup method prottekbar call hoibo
    "initial values are correct",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'Test 1', content: 'Test 1 content'),
      Article(title: 'Test 2', content: 'Test 2 content'),
      Article(title: 'Test 3', content: 'Test 3 content'),
    ];

    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test(
      "gets articles using the NewsService",
      () async {
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      """indicates loading of data,
      sets articles to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
