library model.tiebreak;

import 'dart:math' show max;
import 'point.dart';
import 'player.dart';

class Tiebreak {
  num upTo;
  int _pointsPlayer1 = 0;
  int _pointsPlayer2 = 0;
  Id playerServingFirst;
  List<Point> points = [];

  /// Play a tiebreaker
  Tiebreak(this.playerServingFirst, {this.upTo: 7}) {}

  int get pointsPlayer1 => _pointsPlayer1;
  int get pointsPlayer2 => _pointsPlayer2;

  /// Returns who serves the next point
  Id server() {
    int sum = pointsPlayer1 + pointsPlayer2;
    if (sum == 0) return playerServingFirst;
    var g = sum % 4 + 2;
    if (g == 3 || g == 4) return otherPlayer(playerServingFirst);
    else return playerServingFirst;
  }

  bool isFinished() {
    int m = max(pointsPlayer1, pointsPlayer2);
    if (m >= upTo &&
        (pointsPlayer1 - pointsPlayer2) >= 2) return true;
    if (m >= upTo &&
        (pointsPlayer2 - pointsPlayer1) >= 2) return true;
    return false;
  }

  /// Return the Id of the winner.  Throws if tiebreak is not over yet.
  Id winner() {
    if (!isFinished())
      throw 'Tiebreak is not finished yet';
    if (pointsPlayer1 > pointsPlayer2) return Id.p1;
    else return Id.p2;
  }

  void play(Point point) {
    if (isFinished()) throw 'Game has finished';
    points.add(point);
    if (point.hasServerWon) {
      if (server() == Id.p1) _pointsPlayer1 += 1;
      else _pointsPlayer2 += 1;
    } else {
      if (server() == Id.p1) _pointsPlayer2 += 1;
      else _pointsPlayer1 += 1;
    }
  }

  /// the score from the scoreboard point of view
  String orderedScore() => '$pointsPlayer1:$pointsPlayer2';

  /// the score from the point of view of the server
  String prettyScore() {
    if (server() == Id.p1) return '$pointsPlayer1:$pointsPlayer2';
    else return '$pointsPlayer2:$pointsPlayer1';
  }



}
