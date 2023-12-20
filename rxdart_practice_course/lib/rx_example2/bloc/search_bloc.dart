import 'package:flutter/material.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_practice_course/rx_example2/api.dart';
import 'package:rxdart_practice_course/rx_example2/search_resutls.dart';

@immutable 
class SearchBloc{
  final Sink<String> search; //write
  final Stream<SearchResult?> results; //read
   
  void dispose(){search.close();}

  const SearchBloc._({required this.search, required this.results});

  factory SearchBloc({required Api api}){
    final textChanges = BehaviorSubject<String>();
    final results = textChanges.distinct().debounceTime(const Duration(seconds: 1))
      .switchMap<SearchResult?>((searchTerm) {
        if(searchTerm.isEmpty){return Stream<SearchResult?>.value(null);}
        else{
          return Rx.fromCallable(() => api.getFromRemote(searchTerm)).delay(const Duration(seconds: 1))
          .map((result) => result.isEmpty ? const SearchResultNoResult() : SearchResultWithResults(result))
          .startWith(const SearchResultLoading()).onErrorReturnWith((error, _) => SearchResultWithError(error));
        }
      });
    return SearchBloc._(search:textChanges.sink, results: results);
  }
}