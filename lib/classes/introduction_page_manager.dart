/// Manages the pages and current page of the [IntroductionScreen].
///
/// This class is responsible for managing the introduction pages, including
/// their content, the current page, and navigation between pages.
class IntroductionPageManager {
  IntroductionPageManager();
  int _currentPage = 0;
  final List<_IntroductionPageModel> _pages = [
    const _IntroductionPageModel(
      title: "Bem vindo(a)!",
      text:
          "É muito bom ter você aqui no Weather.App. Avance essa introdução para ver as funcionalidade do app",
      image: "svg/logo.svg",
      showBackground: false,
    ),
    const _IntroductionPageModel(
      title: "Informações do clima",
      text:
          "Você pode ver não só a temperatura da cidade, mas também o clima, previsão pras próximas 24 horas, sensação térmica, velocidade do vento e mais!",
      image: "images/secondPage.png",
      showBackground: true,
    ),
    const _IntroductionPageModel(
      title: "Previsões para semana",
      text:
          "É possível ver também o clima e a temperatura máxima e mínima pros próximos dias da semana!",
      image: "images/thirdPage.png",
      showBackground: true,
    ),
    const _IntroductionPageModel(
      title: "Localizar cidade",
      text:
          "Para localizar a cidade você pode pesquisar na barra de pesquisa, mover o mapa ou usar o GPS do dispositivo!",
      image: "images/forthPage.png",
      showBackground: true,
    ),
  ];

  /// This get function is used to use [_pages] in other files
  get pages {
    return _pages;
  }

  /// This get function is used to use [_currentPage] in other files
  get currentPage {
    return _currentPage;
  }

  /// This function is used to increment the current page
  void incrementPage() {
    _currentPage++;
  }

  /// This function is used to decrement the current page
  void decrementPage() {
    _currentPage--;
  }

  /// This function is used to change the current page to a specic [index]
  void changePage(int index) {
    _currentPage = index;
  }

  /// Check if the current step is the first one.
  ///
  /// Returns true if the current step is 0 (the first step), otherwise returns
  /// false.
  bool isFirstStep() {
    return _currentPage == 0;
  }

  /// Check if the current step is the last one.
  ///
  /// Returns true if the current step is equal to the total number of steps
  /// minus one, indicating it's the last step. Otherwise, it returns false.
  bool isLastStep() {
    return _currentPage == _pages.length - 1;
  }
}

class _IntroductionPageModel {
  /// Model class representing a page in the [IntroductionScreen].
  ///
  /// This model class is used to encapsulate the properties of an introduction page, including:
  /// - [title]: The title of the page.
  /// - [text]: The descriptive text of the page.
  /// - [image]: The image associated with the page.
  /// - [showBackground]: A boolean indicating whether the background should be visible for this page.
  const _IntroductionPageModel({
    required this.title,
    required this.text,
    required this.image,
    required this.showBackground,
  });
  final String title;
  final String text;
  final String image;
  final bool showBackground;
}
