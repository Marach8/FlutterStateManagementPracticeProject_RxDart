import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example2/classes.dart';
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
          else if(result is SearchResultWithError){return Text(result.error.toString());}
          else if(result is SearchResultWithResults){
            final results = result.results;
            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, listIndex){
                  final item = results.elementAt(listIndex);
                  final String title;
                  if(item is Animal){title = 'Animal';}
                  else if(item is Person){title = 'Person';}
                  else {title = 'Unknown';}
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString())
                  );
                }
              )
            );
          } else {return const Text('Unknown State');}
        } 
        else{return const Text('Waiting...');}
      }
    );
  }
}