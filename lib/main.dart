import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import 'dart:developer' as devtools;

class Testimony {
  final String type;
  final String description;
  final String imageUrl;
  final DateTime created;
  final bool isUpdated;

  bool left = true;

  Testimony({
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.created,
    required this.isUpdated,
  });
}
// once the first isUpdated is reached, switch sides,  (first doesn't count)
// [
//   {
//      left: [],
//      right: [],
//   }
// ]

final testimonies = [
  Testimony(
    isUpdated: true,
    type: 'healing',
    description: 'My Description',
    imageUrl: 'images/media-placeholder.png',
    created: DateTime.parse('2022-11-12'),
  ),
  Testimony(
    isUpdated: false,
    type: 'healing',
    description: 'My Description',
    imageUrl: '',
    created: DateTime.parse('2022-11-03'),
  ),
  Testimony(
    isUpdated: false,
    type: 'healing',
    description: 'My Description',
    imageUrl: '',
    created: DateTime.parse('2022-11-01'),
  ),
  Testimony(
    isUpdated: false,
    type: 'deliverance',
    description: 'My Description',
    imageUrl: '',
    created: DateTime.parse('2022-10-30'),
  ),
  Testimony(
    isUpdated: true,
    type: 'healing',
    description: 'My Description',
    imageUrl: 'images/media-placeholder.png',
    created: DateTime.parse('2022-10-28'),
  ),
  Testimony(
    isUpdated: false,
    type: 'testimony',
    description: 'My Description',
    imageUrl: '',
    created: DateTime.parse('2022-10-25'),
  ),
  Testimony(
    isUpdated: false,
    type: 'salvation',
    description: 'My Description',
    imageUrl: '',
    created: DateTime.parse('2022-10-24'),
  ),
];

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool left = true;

  late final List<Testimony> list;

  @override
  void initState() {
    super.initState();
    list = layout();
  }

  List<Testimony> layout() {
    return testimonies.map((testimony) {
      // Switch sides once you hit an isUpdated testimony
      if (testimony.isUpdated) {
        left = !left;
      }
      // Asign the side to the testimony
      return testimony..left = left;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              FixedTimeline.tileBuilder(
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                builder: TimelineTileBuilder.connectedFromStyle(
                  // Left Side
                  oppositeContentsBuilder: (context, index) {
                    final testimony = list[index];
                    if (!testimony.left) return const SizedBox.shrink();

                    final date = testimony.created;
                    final dateText = DateFormat('MMMM dd, yyyy').format(date);

                    if (!testimony.isUpdated) {
                      return SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                            ),
                            Text(testimony.type)
                          ],
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              constraints: const BoxConstraints.expand(height: 70.0),
                              width: double.infinity,
                              child: Image.asset(
                                'images/media-placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(testimony.type),
                            Text(testimony.description),
                            Text(dateText),
                          ],
                        ),
                      ),
                    );
                  },
                  // Right Side
                  contentsBuilder: (context, index) {
                    final testimony = list[index];
                    if (testimony.left) return const SizedBox.shrink();

                    final date = testimony.created;
                    final dateText = DateFormat('MMMM dd, yyyy').format(date);

                    // switch sides as soon as is updated true

                    if (!testimony.isUpdated) {
                      return SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                            ),
                            Text(testimony.type)
                          ],
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.red,
                                ),
                              ),
                              constraints: const BoxConstraints.expand(height: 70.0),
                              width: double.infinity,
                              child: Image.asset(
                                'images/media-placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(testimony.type),
                            Text(testimony.description),
                            Text(dateText),
                          ],
                        ),
                      ),
                    );
                  },
                  connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                  itemCount: list.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
