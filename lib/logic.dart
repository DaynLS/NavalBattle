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
}

class Field extends StatelessWidget {
  final int gridSize;
  final double cellSize;
  final List<bool> ships;
  final List<bool>? hits;
  final bool playerRecognition;
  final void Function(int) onCellTap;

  const Field({
    super.key,
    required this.gridSize,
    required this.cellSize,
    required this.ships,
    this.hits,
    required this.playerRecognition,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        childAspectRatio: 1.0,
      ),
      itemCount: gridSize * gridSize,
      itemBuilder: (context, index) {
        bool isShip = ships[index];
        bool isHit = hits != null && hits![index];
        return GridCell(
          index: index,
          size: cellSize,
          isShip: isShip,
          isHit: isHit,
          playerRecognition: playerRecognition,
          onTap: () => onCellTap(index),
        );
      },
    );
  }
}

class GridCell extends StatelessWidget {
  final int index;
  final double size;
  final bool isShip;
  final bool isHit;
  final bool playerRecognition;
  final VoidCallback onTap;

  const GridCell({
    super.key,
    required this.index,
    required this.size,
    required this.isShip,
    required this.isHit,
    required this.playerRecognition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.2),
          color: isHit && isShip
              ? Colors.red
              : isHit
              ? Colors.black
              : isShip && !playerRecognition
              ? Colors.red.withOpacity(0.5)
              : isShip
              ? Colors.blue
              : Colors.transparent,
        ),
      ),
    );
  }
}