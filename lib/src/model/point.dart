library model.point;



Map<int, Map> category = {
  1: {'comment': 'double fault', 'score': -1},
  2: {'comment': 'service return error', 'score': 1},
  3: {'comment': 'unforced error groundstroke'},
  4: {'comment': 'volley error'},
  5: {'comment': 'service ace', 'score': 1},
  6: {'comment': 'groundstroke winner'},
  7: {'comment': 'lob winner'},
  8: {'comment': 'volley/overhead winner'}
};



class Point {
  bool hasServerWon;
  int serverShotId;
  int returnerShotId;

  Point(this.hasServerWon, {this.serverShotId, this.returnerShotId}) {
    if (hasServerWon) {
      if (category['score'] ==
          -1) throw 'Server could not have won with ${category[serverShotId]}';
    } else {
      if (category['score'] ==
          1) throw 'Returner could not have won the point with ${category[returnerShotId]}';
    }
  }
}

