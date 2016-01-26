library model.match;

import 'tiebreak.dart';

enum MatchFormat { twoSetsAndSuperTb, bestOfThree, bestOfFive }

class Match {
  MatchFormat matchFormat;
  SetWinningRule setWinningRule;
  int _setsPlayer1 = 0;
  int _setsPlayer2 = 0;

  Player player1, player2;
  Id playerServingFirst;
  Tiebreak tb;

  Match(this.playerServingFirst, this.matchFormat, this.setWinningRule) {
    if (matchFormat == MatchFormat.twoSetsAndSuperTb) {
      tb = new Tiebreak(playerServingFirst, upTo: 10);
    }
  }

  void playPoint() {}

  /// Check if the match is finished.
  bool isFinished() {
    if (matchFormat == MatchFormat.twoSetsAndSuperTb) {
      if (setsPlayer1 == 2 || setsPlayer2 == 2 || tb.isFinished()) return true;
    } else {
      throw 'Match format $matchFormat not implemented yet';
    }
    return false;
  }

  /// number of sets won by player 1
  int get setsPlayer1 => _setsPlayer1;

  /// number of sets won by player 2
  int get setsPlayer2 => _setsPlayer2;
}
