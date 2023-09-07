import 'dart:math' as math show Random;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

const names = [
  'foo',
  'bar',
  'baz',
];

extension RandomElement<T> on List<T> {
  T get randomElement => this[math.Random().nextInt(length)];
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    emit(names.randomElement);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            final button = ElevatedButton(
              onPressed: cubit.pickRandomName,
              child: const Text('Pick a random name'),
            );
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return Column(
                  children: [
                    button,
                    const SizedBox(height: 16),
                    Text(snapshot.data ?? 'No name picked yet'),
                  ],
                );
              case ConnectionState.active:
                return Column(
                  children: [
                    button,
                    const SizedBox(height: 16),
                    Text(snapshot.data ?? 'No name picked yet'),
                  ],
                );
              case ConnectionState.done:
                return Column(
                  children: [
                    button,
                    const SizedBox(height: 16),
                    Text(snapshot.data ?? 'No name picked yet'),
                  ],
                );
            }
          },
        ));
  }
}
