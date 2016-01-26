library model.player;


/// A player id, to identify during the match.  Player 1 and player 2.
enum Id { p1, p2 }

Id otherPlayer(Id one) {
  if (one == Id.p1) return Id.p2;
  else return Id.p1;
}

class Player {
  String name;
  int id;

  Player(this.name);
}
