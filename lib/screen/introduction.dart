import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/screen/map_screen.dart';

/// The main widget representing the introduction screen.
///
/// This widget displays a series of pages to introduce users to the WeatherApp.
/// It provides information about app features and functionality.
class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
        child: _PageList(
          pages: [
            _Page(
              widget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: SvgPicture.asset("svg/Logo.svg"),
              ),
              showBackground: false,
              title: "Bem vindo(a)!",
              text:
                  "É muito bom ter você aqui no Weather.App. Avance essa introdução para ver as funcionalidade do app",
            ),
            _Page(
              widget: Image.asset(
                "images/first_slide.png",
                height: 325,
              ),
              showBackground: true,
              title: "Informações do clima",
              text:
                  "Você pode ver não só a temperatura da cidade, mas também o clima, previsão pras próximas 8 horas, sensação térmica, velocidade do vento e mais!",
            ),
            _Page(
              widget: Image.asset(
                "images/second_slide.png",
                height: 325,
              ),
              showBackground: true,
              title: "Previsões para semana",
              text:
                  "É possível ver também o clima e a temperatura máxima e mínima pros próximos dias da semana",
            ),
            _Page(
              widget: Image.asset(
                "images/third_slide.png",
                height: 325,
              ),
              showBackground: true,
              title: "Localizar cidade",
              text:
                  "Parar localizar a cidade você pesquisa na barra de pesquisa, mover o mapa ou usar o GPS do dispositivo",
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget manages a list of pages and their navigation.
///
/// [pages] is the list of pages to be displayed to the user. It should contain
/// only [_Page] widgets.
///
/// This widget provides navigation controls to move between pages and includes
/// a step indicator to track the progress.
class _PageList extends StatefulWidget {
  final List<_Page> pages;
  const _PageList({super.key, required this.pages});

  @override
  State<_PageList> createState() => _PageListState();
}

class _PageListState extends State<_PageList> {
  final PageController controller = PageController();
  int steps = 0;

  void pageHandler(int index) {
    setState(() {
      steps = index;
    });
  }

  /// Check if is the first page
  bool isFirstStep() {
    return steps == 0;
  }

  /// Check if is the last page
  bool isLastStep() {
    return steps == widget.pages.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: !isLastStep(),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                child: Text(
                  "Pular",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: pageHandler,
              children: widget.pages,
            ),
          ),
          _StepsIndicator(
            currentStep: steps,
            numberOfSteps: widget.pages.length,
            isFirstStep: isFirstStep(),
            isLastStep: isLastStep(),
            nextStep: () {
              controller.animateToPage(
                steps + 1,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
            previousStep: () {
              controller.animateToPage(
                steps - 1,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
          )
        ],
      ),
    );
  }
}

/// Represents the page in the introduction screen
///
/// This widget displays content to the user, typically an image, text, or other widgets.
///
/// [widget]: The main content to be displayed on the page.
/// [title]: The description or additional text content of the page.
/// [text]: The description or additional text content of the page.
/// [showBackground]: A boolean that control the visibility of the background
class _Page extends StatelessWidget {
  final Widget widget;
  final String title;
  final String text;
  final bool showBackground;
  const _Page(
      {super.key,
      required this.title,
      required this.text,
      required this.widget,
      required this.showBackground});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: showBackground,
                  child: SvgPicture.asset(
                    "svg/slide_background.svg",
                  ),
                ),
              ),
              Positioned(left: 0, right: 0, bottom: 0, child: widget),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 300,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// This widget represents a navigation control for managing steps and page navigation.
///
/// It provides a step indicator and navigation buttons.
///
/// [currentStep]: The current step.
/// [numberOfSteps]: The total number of steps.
/// [isFirstStep]: A boolean indicating if it's the first step.
/// [isLastStep]: A boolean indicating if it's the last step.
/// [nextStep]: A function that allows navigation to the next step.
/// [prevStep]: A function that allows navigation to the previous step.
class _StepsIndicator extends StatelessWidget {
  final int currentStep;
  final int numberOfSteps;
  final bool isFirstStep;
  final bool isLastStep;
  final VoidCallback nextStep;
  final VoidCallback previousStep;
  const _StepsIndicator(
      {super.key,
      required this.currentStep,
      required this.numberOfSteps,
      required this.isFirstStep,
      required this.isLastStep,
      required this.nextStep,
      required this.previousStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Visibility(
              visible: !isFirstStep,
              child: InkWell(
                onTap: previousStep,
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 175,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < numberOfSteps; i++) ...[
                currentStep == i
                    ? Container(
                        height: 8,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(90)),
                      )
                    : Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(90)),
                      )
              ]
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: isLastStep
                ? InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()),
                      );
                    },
                    child: Text(
                      "Ir pro mapa",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.end,
                    ),
                  )
                : InkWell(
                    onTap: nextStep,
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
