import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/classes/introduction_page_manager.dart';
import 'package:weather_app/components/introduction_page.dart';
import 'package:weather_app/screen/map_screen.dart';

final IntroductionPageManager _pageManager = IntroductionPageManager();

class IntroductionScreen extends StatefulWidget {
  /// The primary widget for the introduction screen.
  ///
  /// This widget serves as an introduction to the app, presenting a series of pages with
  /// welcome messages and explanations of the app's functionality. Each page includes
  /// an image, a title, and a descriptive text that introduces different aspects of the app.
  ///
  /// At the bottom of the screen, the [_StepsIndicator] helps navigate between pages and
  /// transition to the [MapScreen] when the introduction is completed. Additionally, there's
  /// a "Pular" (Skip) button at the top of the screen for users who want to skip the introduction
  /// and go directly to the [MapScreen].
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController controller = PageController();

  /// Handle page navigation and update the screen state.
  ///
  /// This function is responsible for updating the state of the screen when navigation
  /// between pages occurs. It takes an integer parameter [index] representing the
  /// index of the page being navigated to. It should be called whenever a page change
  /// event happens in your application.
  ///
  /// Parameters:
  /// - [index]: The index of the page to which navigation is occurring.
  void pageHandler(int index) {
    setState(() {
      _pageManager.changePage(index);
    });
  }

  /// Navigate to the next or previous page in the introduction and handle screen transitions.
  ///
  /// This function is responsible for navigating between pages in the introduction screen.
  /// It takes a void callback parameter [updateCurrentPage] to update the current page.
  /// If the current page is the last one, this function will navigate to the [MapScreen].
  ///
  /// Parameters:
  /// - [updateCurrentPage]: A void callback to update the [_currentPage] of [_pageManager].
  ///   This parameter typically comes from [_pageManager] and can be the [incrementPage] function
  ///   to increment the current page by 1, the [decrementPage] function to decrement it by 1,
  ///   or [changePage] to change the current page to a specific index.
  ///
  /// After navigating to the [MapScreen], this function sets a flag in shared preferences
  /// to indicate that the introduction screen has been passed, and the user won't see
  /// it again until the cache is reset.
  void swipePage(VoidCallback updateCurrentPage) async {
    updateCurrentPage();
    if (_pageManager.currentPage != _pageManager.pages.length) {
      controller.animateToPage(
        _pageManager.currentPage,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setBool("hasPassedIntroScreen", true);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 35, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _Buttons(
                onPressed: () => swipePage(
                  () => _pageManager.changePage(_pageManager.pages.length),
                ),
                child: Text(
                  "Pular",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: pageHandler,
                children: [
                  for (int i = 0; i < _pageManager.pages.length; i++) ...[
                    IntroductionPageWidget(
                      title: _pageManager.pages[i].title,
                      text: _pageManager.pages[i].text,
                      image: _pageManager.pages[i].image,
                      showBackground: _pageManager.pages[i].showBackground,
                    )
                  ]
                ],
              ),
            ),
            _StepsIndicator(
              currentStep: _pageManager.currentPage,
              numberOfSteps: _pageManager.pages.length,
              nextStep: () => swipePage(_pageManager.incrementPage),
              previousStep: () => swipePage(_pageManager.decrementPage),
            )
          ],
        ),
      ),
    );
  }
}

class _StepsIndicator extends StatelessWidget {
  /// Widget that controls navigation between pages and displays step indicators.
  ///
  /// This widget consists of a row with two buttons to navigate to the next and previous steps.
  /// In the center of the row, it displays step indicators as small containers representing the total number
  /// of steps, with the current step being highlighted in blue and slightly wider.
  ///
  /// Parameters:
  /// - [currentStep]: The current step;
  /// - [numberOfSteps]: The total number of steps;
  /// - [nextStep]: Function to navigate to the next step;
  /// - [previousStep]: Function to navigate to the previous step.
  const _StepsIndicator({
    required this.currentStep,
    required this.numberOfSteps,
    required this.nextStep,
    required this.previousStep,
  });

  final int currentStep;
  final int numberOfSteps;
  final VoidCallback nextStep;
  final VoidCallback previousStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: !_pageManager.isFirstStep() ? 1 : 0,
                child: _Buttons(
                  onPressed: previousStep,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < numberOfSteps; i++) ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 8,
                    width: currentStep == i ? 30 : 8,
                    decoration: BoxDecoration(
                      color: currentStep == i
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(90),
                    ),
                  )
                ]
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                key: ValueKey<bool>(_pageManager.isLastStep()),
                child: _pageManager.isLastStep()
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: _Buttons(
                          onPressed: nextStep,
                          child: Text(
                            "Ir pro mapa",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.centerRight,
                        child: _Buttons(
                          onPressed: nextStep,
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 30,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  /// Widget to create a button.
  ///
  /// This widget represents a customizable button with rounded corners and a
  /// transparent fill. It's designed to create interactive UI elements
  /// and accepts the following parameters:
  ///
  /// - [onPressed]: A callback function that will be executed when the button is pressed.
  /// - [child]: The content (e.g., text, icon) to be displayed inside the button.
  const _Buttons({required this.onPressed, required this.child});
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      child: child,
    );
  }
}
