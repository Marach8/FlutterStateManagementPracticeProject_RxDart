import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example2/search_resutls.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchResultView({required this.searchResult, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
      stream: searchResult,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final result = snapshot.data!;
          if(result is SearchResultLoading){return const CircularProgressIndicator();}
          else if(result is SearchResultNoResult){return const Text('No matches found! Try with another');}
          else if(result is SearchResultWithError){return const Text('An error occured. Please Try again.');}
          else if(result is SearchResultWithResults){
          
          }
        } 
        else{return const Text('Waiting...');}
      }
    );
  }
}