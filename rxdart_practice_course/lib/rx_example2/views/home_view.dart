import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example2/api.dart';
import 'package:rxdart_practice_course/rx_example2/bloc/search_bloc.dart';
import 'package:rxdart_practice_course/rx_example2/views/searchresults_view.dart';

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  late final SearchBloc _bloc;

  @override 
  void initState(){super.initState(); _bloc = SearchBloc(api: Api());}


  @override 
  void dispose(){_bloc.dispose(); super.dispose();}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: true),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter a search term here...'
            ),
            onChanged: _bloc.search.add,
          ),
          const SizedBox(height: 10),
          SearchResultView(searchResult: _bloc.results)
        ]
      )
    );
  }
}