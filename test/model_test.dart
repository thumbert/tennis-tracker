library model.test;

import 'dart:collection' show LinkedHashMap;
import 'package:test/test.dart';
import 'package:tennis_tracker/tennis_tracker.dart';


gameTest() {
  group('Test Game', () {
    test('game scoring', () {
      Game game = new Game(Id.p1);

      expect(game.prettyScore(), '0:0');
      game.play(new Point(true));
      expect(game.isFinished(), false);

      expect(game.prettyScore(), '15:0');
      game.play(new Point(true));
      expect(game.isFinished(), false);

      expect(game.prettyScore(), '30:0');
      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '30:15');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:15');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:30');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:40');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '-:AD');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:40');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), 'AD:-');

      game.play(new Point(true));
      expect(game.isFinished(), true);
    });

    test('is finished', () {
      Game game = new Game(Id.p1);
      var win = [true, false, true, false, true, false, true, true];
      win.forEach((b){
        game.play(new Point(b));
      });
      expect(game.isFinished(), true);
      expect(game.pointsPlayer1, 5);
      expect(game.pointsPlayer2, 3);
    });

    test('with AD scoring for receiver', () {
      Game game = new Game(Id.p1);
      var win = [true, false, true, false, true, false, false, true];
      win.forEach((b){
        game.play(new Point(b));
      });
      expect(game.isFinished(), false);
      expect(game.orderedScore(), '40:40');
      game.play(new Point(false));
      expect(game.orderedScore(), '-:AD');
      game.play(new Point(false));
      expect(game.orderedScore(), '0:1');
    });

    test('scoring', () {
      Game game = new Game(Id.p2);
      var win = [false, true, false, true, false, true, false];
      var expPretty  = '|0:15|15:15|15:30|30:30|30:40|40:40|-:AD';
      var expOrdered = '|15:0|15:15|30:15|30:30|40:30|40:40|AD:-';
      var actPretty = '';
      var actOrdered = '';
      win.forEach((b){
        game.play(new Point(b));
        actPretty = actPretty + '|' + game.prettyScore();
        actOrdered = actOrdered + '|' + game.orderedScore();
      });
      expect(expPretty, actPretty);
      expect(expOrdered, actOrdered);
    });


  });
}


tiebreakerTest() {
  group('Tiebreaker test', () {
    test('server order', () {
      Tiebreak tb = new Tiebreak(Id.p2, upTo: 7);
      var order = [
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2,
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2,
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2
      ];
      for (int i = 0; i < 10; i++) {
        tb.play(new Point(true));
        expect(tb.server(), order[i]);
      }
    });
    test('scoring', () {
      Tiebreak tb = new Tiebreak(Id.p1, upTo: 7);
      var scores = ['0:1', '1:1', '1:2', '2:2', '2:3', '3:3'];
      for (int i = 0; i < 6; i++) {
        tb.play(new Point(true));
        expect(tb.prettyScore(), scores[i]);
      }
    });
    test('is finished', () {
      Tiebreak tb = new Tiebreak(Id.p1, upTo: 7);
      var win = [true, false, false, true, true, true, true, true, true];
      win.forEach((b) {
        tb.play(new Point(b));
      });
      expect(tb.prettyScore(), '2:7');
      expect(tb.isFinished(), true);
    });
  });
}




setTest() {
  group('Set tests', (){
    test('is finished', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);

    });
    test('set serving order', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
      set.gamesPlayer1 = 1;
      set.gamesPlayer2 = 0;
      expect(set.server(), Id.p2);
      set.gamesPlayer2 = 1;
      //expect(set.server(), Id.p1);
      set.gamesPlayer1 = 4;
      //expect(set.server(), Id.p1);

    });

    test('set goes to tiebreak', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
      set.gamesPlayer1 = 6;
      set.gamesPlayer2 = 6;
      expect(set.server(), Id.p1);
      set.play(new Point(true));
    });

  });
}

/**
 * Count the distinct elements of the iterable x.
 * Return a map with keys the distinct values in x, and the values the count of
 * that value.
 */
Map count(Iterable x) {
  Map grp = {};
  x.forEach((e) {
    if (grp.containsKey(e)) grp[e] += 1;
    else grp[e] = 1;
  });

  return grp;
}

/**
 * Sort a map by values
 */
Map sortMap(Map m, Comparator f) {
  var sortedKeys = m.keys.toList(growable:false)..sort(f);
  LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => m[k]);
  return sortedMap;
}

syntheticGames() {
  var games = new List.generate(100000, (i) => simulateGame(Id.p1));
  var c = count(games.map((Game g) => g.score.length));
  Comparator f = (int k1, int k2) => k1.compareTo(k2);
  var sc = sortMap(c, f);
  sc.forEach((k,v) => print('$k: $v'));


}

syntheticSets() {
  var sets = new List.generate(1000, (i) => simulateSet(Id.p1));
  sets.forEach((TSet s) => print(s.orderedScore()));

  Comparator f = (String k1, String k2) {
    int v1 = int.parse(k1[0]) - int.parse(k1[2]);
    int v2 = int.parse(k2[0]) - int.parse(k2[2]);
    return v1.compareTo(v2);
  };

  var c = count(sets.map((TSet s) => s.orderedScore()));
  var sc = sortMap(c, f);
  sc.forEach((k,v) => print('$k'));
  sc.forEach((k,v) => print('$v'));
}



main() {

//  Game g = simulateGame(Id.p1, seed: 1);
//  print(g.prettyScore());
//  print(g.winner);
//  print(g.score);

  TSet set = simulateSet(Id.p1, seed: 5, log: true);

  //syntheticGames();
  //syntheticSets();
  //simulateTiebreak(Id.p1, seed: 1);

//  tiebreakerTest();
//  gameTest();
//  setTest();


}
