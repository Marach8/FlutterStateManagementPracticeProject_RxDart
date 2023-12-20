import 'package:flutter/material.dart' show immutable;
import 'package:rxdart_practice_course/rx_example2/classes.dart';

@immutable 
abstract class SearchResult{const SearchResult();}

@immutable 
class SearchResultLoading implements SearchResult{const SearchResultLoading();}

@immutable 
class SearchResultNoResult implements SearchResult{const SearchResultNoResult();}

@immutable 
class SearchResultWithError implements SearchResult{
  final Object error;
  const SearchResultWithError(this.error);
}

@immutable 
class SearchResultWithResults implements SearchResult{
  final List<Thing> results;
  const SearchResultWithResults(this.results);
}