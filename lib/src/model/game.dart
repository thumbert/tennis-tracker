library model.game;

import 'point.dart';
import 'player.dart';

enum GameWinningRule { normal, noAdScoring }

class Game {
  List<Point> points = [];
  int _pointsPlayer1 = 0;
  int _pointsPlayer2 = 0;

  /// the score from the point of view of the server
  /// value = 1 if server wins, -1 if returner wins.
  List<int> score = [];

  /// number of winners and errors from the point of view of the server
  int w = 0, e = 0;
  Id playerServing;

  static List<String> values = ['0', '15', '30', '40', 'AD'];

  Game(this.playerServing) {}

  /// Return the Id of the player who won the game.  Will throw
  /// if the game has not finished yet.
  Id get winner {
    Id res;
    if (isFinished()) {
      if (pointsPlayer1 > pointsPlayer2) return Id.p1;
      else return Id.p2;
    } else throw 'Game has not finished yet';
    return res;
  }

  /// How many points have been won by player 1
  int get pointsPlayer1 => _pointsPlayer1;

  /// How many points have been won by player 2
  int get pointsPlayer2 => _pointsPlayer2;

  /// number of points played
  int get pointsPlayed => _pointsPlayer1 + _pointsPlayer2;

  void play(Point point) {
    if (isFinished()) throw 'Game has finished';
//    if (score.length == 7)
//      print('hi');
    points.add(point);
    if (point.hasServerWon) {
      if (playerServing == Id.p1) _pointsPlayer1 += 1;
      else _pointsPlayer2 += 1;
      w += 1;
      score.add(1);
    } else {
      if (playerServing == Id.p1) _pointsPlayer2 += 1;
      else _pointsPlayer1 += 1;
      e += 1;
      score.add(-1);
    }
  }

  /// Score from the point of view of the server.
  String prettyScore() {
    String res;
    if (isFinished())
      return w > e ? '1:0' : '0:1';

    if (score.length <= 6) {
      res = '${Game.values[w]}:${Game.values[e]}';
    } else {
      if (score.length % 2 == 0) {
        res = '40:40';
      } else {
        if (w > e) res = 'AD:-';
        if (w < e) res = '-:AD';
      }
    }
    return res;
  }

  /// Score for the electronic scoreboard.
  String orderedScore() {
    String res;
    if (isFinished()) return w > e ? '1:0' : '0:1';
    if (score.length <= 6) {
      res = '${Game.values[pointsPlayer1]}:${Game.values[pointsPlayer2]}';
    } else {
      if (score.length % 2 == 0) {
         res = '40:40';
      } else {
        if (_pointsPlayer1 > _pointsPlayer2) res = 'AD:-';
        else res = '-:AD';
      }
    }

    return res;
  }

  /// Show if the game is finished or not.
  bool isFinished() {
    bool res = false;
    if (score.length >= 4) {
      /// more than 4 points or more have been played, so it could be over
      if (score.length < 7) {
        if (w == 4 || e == 4) return true;
      } else if (score.length % 2 == 0 && (w - e).abs() == 2) {
        return true;
      }
    }
    return res;
  }
}
