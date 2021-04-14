import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const String _loremIpsumParagraph =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus cras adipiscing enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae.\n';

const String _image0 =
    'https://images.unsplash.com/photo-1544198365-f5d60b6d8190?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80';

const String _image1 =
    'https://images.unsplash.com/photo-1586099079958-3b7975abb2fa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1280&q=80';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showList = true;
  bool _slowAnimations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations Package'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() => _showList = !_showList),
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _showList ? ListExample() : GridExample(),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SwitchListTile(
          value: _slowAnimations,
          onChanged: (value) async {
            setState(() => _slowAnimations = value);
            // Wait until the Switch is done animating before actually slowing
            // down time.
            if (_slowAnimations) {
              await Future<void>.delayed(const Duration(milliseconds: 300));
            }
            timeDilation = _slowAnimations ? 8.0 : 1.0;
          },
          title: const Text('Slow animations'),
        ),
      ),
    );
  }
}

class ListExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return ListTile(
              leading: Image.network(
                _image0,
                width: 60.0,
                fit: BoxFit.cover,
              ),
              title: Text('Title $index'),
              onTap: openContainer,
            );
          },
          openBuilder: (BuildContext _, VoidCallback __) {
            return DetailScreen(
              title: 'Title $index',
              imageUrl: _image0,
            );
          },
          onClosed: (_) => print('Closed'),
        );
      },
    );
  }
}

class GridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return GestureDetector(
                onTap: openContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      _image1,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8.0),
                    Text('Title $index'),
                  ],
                ),
              );
            },
            openBuilder: (BuildContext _, VoidCallback __) {
              return DetailScreen(
                title: 'Title $index',
                imageUrl: _image1,
              );
            },
            onClosed: (_) => print('Closed'),
          ),
        );
      },
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _largePhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        reverse: !_largePhoto,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
          );
        },
        child: _largePhoto
            ? GestureDetector(
                onTap: () => setState(() => _largePhoto = !_largePhoto),
                child: Image.network(
                  widget.imageUrl,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _largePhoto = !_largePhoto),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(widget.title),
                    const SizedBox(height: 20.0),
                    const Text(_loremIpsumParagraph),
                  ],
                ),
              ),
      ),
    );
  }
}
