library model.tennis_set;

import 'tiebreak.dart';
import 'game.dart';
import 'player.dart';
import 'point.dart';

enum SetWinningRule { winByTwoGames, tiebreakTo7 }


class TSet {
  SetWinningRule setWinningRule;
  List<Game> games = [];
  int _gamesPlayer1 = 0;
  int _gamesPlayer2 = 0;
  Tiebreak tb;
  bool inTiebreaker = false;
  Id playerServingFirst;
  Game currentGame;

  /// A tennis set
  TSet(this.playerServingFirst, this.setWinningRule) {
    currentGame = new Game(playerServingFirst);
  }


  /// number of games won by player 1
  int get gamesPlayer1 => _gamesPlayer1;

  /// number of games won by player 2
  int get gamesPlayer2 => _gamesPlayer2;

//  /// If you want to move ahead, because of a scoring mistake.
//  void moveTo(int g1, int g2) {
//
//  }

  /// Return the current server
  Id server() {
    if (inTiebreaker) {
      return tb.server();
    } else {
      return currentGame.playerServing;
    }
  }

  /// Play the set one point at a time.  Throws if a point is
  /// played after the set is finished.
  void play(Point point) {
    if (isFinished()) throw 'Set is finished.';

    /// set is not finished, so play a point!
    if (inTiebreaker) {
      tb.play(point);
      /// maybe it was the last point of the tiebreaker
      if (tb.isFinished()) {
        if (tb.winner() == Id.p1) _gamesPlayer1 += 1;
        else _gamesPlayer2 += 1;
      }
    } else {
      currentGame.play(point);
      /// maybe it was the last point of the game
      if (currentGame.isFinished()) {
        games.add(currentGame);
        if (currentGame.winner == Id.p1) _gamesPlayer1 += 1;
        else _gamesPlayer2 += 1;

        if (setWinningRule == SetWinningRule.tiebreakTo7 && gamesPlayer1 == 6
            && gamesPlayer2 == 6) {
          /// got to the tiebreaker
          inTiebreaker = true;
          tb = new Tiebreak(otherPlayer(currentGame.playerServing), upTo: 7);
          currentGame = null;
        } else {
          /// play a new game, change the server
          currentGame = new Game(otherPlayer(currentGame.playerServing));
        }
      }
    }
  }

  /// Check if the set is finished.
  bool isFinished() {
    bool res = false;

    bool upBy2 = (gamesPlayer1 - gamesPlayer2).abs() >= 2;
    if ((gamesPlayer1 == 6 || gamesPlayer2 == 6) && upBy2) return true;

    if (setWinningRule == SetWinningRule.tiebreakTo7) {
      if (tb != null && tb.isFinished()) return true;
      if ((gamesPlayer1 > 6 || gamesPlayer2 > 6) && upBy2) return true;
    } else {
      throw 'Only tiebreakTo7 set winning rule is implemented';
    }

    return res;
  }

  /// Score as shown on the scoreboard, player 1:player2
  String orderedScore() {
    String res = '$gamesPlayer1-$gamesPlayer2';
    if (!isFinished()) {
      if (inTiebreaker) {
        if (tb.points.length == 0) {
          String player = (server() == Id.p1) ? '1' : '2';
          res = res + ', p$player to serve';
        } else {
          res = res + ' ${tb.orderedScore()}';
        }
      } else {
        if (currentGame.score.length == 0) {
          String player = (server() == Id.p1) ? '1' : '2';
          res = res + ', p$player to serve';
        } else {
          res = res + ' ${currentGame.orderedScore()}';
        }
      }
    }
    return res;
  }


}
