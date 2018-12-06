import 'dart:convert';

import 'package:http/http.dart' as http;

class Fact {
  final String text;
  Fact(this.text);
  Fact.fromMap(Map<String,dynamic> map) : this.text = map["text"];
}

/// A service that returns facts about cats.
abstract class CatFactService {
  /// Get a list of random facts.
  Future<List<Fact>> getRandom();
}

/// A service that has offline data, intented to be used for
/// development or demonstrations.
class MockCatFactService extends CatFactService {
  @override
  Future<List<Fact>> getRandom() {
    return Future.value([
      Fact("Cats use their whiskers to detect if they can fit through a space."),
      Fact("Ever wondered why kittens can all be different colours and look so different from their mums? The fact is that one in four pregnant cats carries kittens fathered by more than one mate. A fertile female may mate with several tom-cats, which fertilise different eggs each time."),
      Fact("Cats aren’t the only animals that purr — squirrels, lemurs, elephants, and even gorillas purr too."),
    ]);
  }
}

/// A service that fetches the free cat-fact API to get random 
/// facts.
class OnlineCatFactService extends CatFactService {
  static const String defaultUrl = "https://cat-fact.herokuapp.com/facts/random?animal=cat&amount=10";

  @override
  Future<List<Fact>> getRandom() async {
    final response = await http.get(defaultUrl);
    if (response.statusCode != 200) {
      throw Exception("Failed to retrieve facts");
    }
    final body = json.decode(response.body) as Iterable<dynamic>;
    return body.map((m) => Fact.fromMap(m)).toList();
  }
}