import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends DashboardEvent {
  final String query;
  const SearchQueryChanged({@required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => 'SearchQueryChanged { query: $query }';
}

class Submitted extends DashboardEvent {
  final String query;

  const Submitted(
      {@required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() {
    return 'Submitted { query: $query }';
  }
}
