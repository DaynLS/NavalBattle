import 'package:flutter/material.dart';

class Game {
  final int gridSize = 10;

  final List<bool> hits = List.generate(100, (_) => false);
  final List<bool> hitsEnemy = List.generate(100, (_) => false);

  bool turn = false;
  bool gameEndFlag = false;
  bool whichWin = false;

  void turnChange(bool isShip, bool plaerRecognition){
    if (!isShip && !plaerRecognition) {
      turn = false;
    }
    else {
      if(!isShip && plaerRecognition){
        turn = true;
      }
    }

  }
  void turnCheck(int index, Ships ship, bool playerRecognition) {
    if (!playerRecognition) {
      hitsEnemy[index] = true;
      bool isShip = ship.ships[index];
      if (gameEnd(ship.ships, hitsEnemy, whichWin, false)) {
        gameEndFlag = true;
        print(1);
      }
      turnChange(isShip, playerRecognition);
    }
    else {
      hits[index] = true;
      bool isShip = ship.shipsEnemy[index];
      if(gameEnd(ship.shipsEnemy, hits, whichWin, true)) {
        gameEndFlag = true;
      }
      turnChange(isShip, playerRecognition);
    }
  }
  bool gameEnd(List<bool> hits, List<bool> ships, bool whichWin, bool playerRecognition){
    int countOfHits = 0;
    for(int index = 0; index < 100; index++) {
      if(ships[index] && hits[index]){
          countOfHits++;
      }
    }
    if (countOfHits == 20 && playerRecognition) {
      this.whichWin = true;
      return true;
      }
    else {
      if(countOfHits == 20 && !playerRecognition) {
        this.whichWin = false;
        return true;
      }
    }
    countOfHits = 0;
    return false;
  }
}

class Ships {
  final List<bool> ships = List.generate(100, (_) => false);
  final List<bool> shipsEnemy = List.generate(100, (_) => false);
  final List<int> indexShipsEnemy = [1,3,5,7, 21,22,23, 25,26,27, 41,42, 44,45, 47,48, 81,82,83,84];

  int shipsCount = 0;

  Ships() {
    for(var index in indexShipsEnemy) {
      shipsEnemy[index] = true;
    }
  }

  bool shipPlacementCheck() {
    if(shipsCount == 20) {
      return true;
    }
    return false;
  }
  void countOfShipsCheck (int index) {
      if (shipsCount < 20) {
        if(!ships[index]) {
          ships[index] = !ships[index];
          shipsCount++;
        }
        else {
          ships[index] = !ships[index];
          shipsCount--;
        }
      }
  }
  Color getCellColor(bool isHit, bool isShip, bool playerRecognition) {
    if (isHit && isShip) {
      return Colors.red;
    } else if (isHit) {
      return Colors.black;
    } else if (isShip && !playerRecognition) {
      return Colors.red.withOpacity(0.5);
    } else if (isShip) {
      return Colors.blue;
    } else {
      return Colors.transparent;
    }
  }
}

class FieldLogic {
  Color getCellColor(bool isHit, bool isShip, bool playerRecognition) {
    if (isHit && isShip) {
      return Colors.red;
    } else if (isHit) {
      return Colors.black;
    } else if (isShip && !playerRecognition) {
      return Colors.red.withOpacity(0.5);
    } else if (isShip) {
      return Colors.blue;
    } else {
      return Colors.transparent;
    }
  }
}