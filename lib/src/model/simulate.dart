library model.simulate;

import 'dart:math' show Random;
import 'game.dart';
import 'player.dart';
import 'tennis_set.dart';
import 'point.dart';
import 'tiebreak.dart';

/// Simulate a tiebreak
Tiebreak simulateTiebreak(Id server, {int seed}) {
  Random r = new Random(seed);
  Tiebreak tb = new Tiebreak(server);
  print(tb.orderedScore());
  while (!tb.isFinished()) {
    tb.play(new Point(r.nextBool()));
    print(tb.orderedScore());
  }
  return tb;
}



/// Simulate a game
Game simulateGame(Id server, {int seed}) {
  Random r = new Random(seed);
  Game game = new Game(server);
  while (!game.isFinished()) {
    game.play(new Point(r.nextBool()));
  }
  return game;
}

/// Simulate a set, or a partial set if [noPoints] is given.
TSet simulateSet(Id server, {int seed, int noPoints: 99999, bool log: false}) {
  Random r = new Random(seed);
  TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
  int i = 0;
  if (log) print(set.orderedScore());
  while(!set.isFinished() && i < noPoints) {
    set.play(new Point(r.nextBool()));
    if (log) print(set.orderedScore());
    i += 1;
  }
  return set;
}


