import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/post_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PostCubit(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    getPosts() {
      context.read<PostCubit>().getPosts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return state.when(
            initial: () => ElevatedButton(
              onPressed: () {
                getPosts();
              },
              child: const Text('Get post'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (post) => ListView.builder(
              itemCount: post.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(post[index].title),
                  subtitle: Text(post[index].body),
                );
              },
            ),
            error: () => ElevatedButton(
              onPressed: () {
                getPosts();
              },
              child: const Text('Retry'),
            ),
          );
        },
      ),
    );
  }
}
