import 'package:flutter/material.dart';
import 'package:nv/logic.dart';

void main() => runApp( const ShipPlacementBackGround());


class ShipPlacementBackGround extends StatelessWidget {
  
  const ShipPlacementBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/BattleShip.jpg"), fit: BoxFit.cover)),
      child: const ShipPlacementScreen(),
      )
    );
  }
}

class ShipPlacementScreen extends StatefulWidget {
  const ShipPlacementScreen({super.key});

  @override
  _ShipPlacementScreen createState() => _ShipPlacementScreen();
}

class _ShipPlacementScreen extends State<ShipPlacementScreen> {
  var ship = Ships();

  void _GameScreenNavigation() {
    if(ship.shipPlacementCheck()) {
      setState(() {
        Navigator.push(
          context,
            MaterialPageRoute(
              builder: (context) => GameBackGround(ship: ship),
            ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Морской бой',
          style: TextStyle(
              color: Colors.black,
              fontSize: 50,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text('Расставьте корабли',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black)),
          ),
          Center(
            child: Container(
              width: 50 * 10,
              height: 50 * 10,
              color: Colors.black26.withOpacity(0.5),
              child: Field(
                gridSize: 10,
                cellSize: 50,
                ships: ship.ships,
                playerRecognition: true,
                onCellTap: (index) {
                  setState(() {
                    ship.countOfShipsCheck(index);
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  _GameScreenNavigation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Начать игру'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class GameBackGround extends StatelessWidget {
  final Ships ship;
  const GameBackGround({super.key, required this.ship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/BattleShip.jpg"), fit: BoxFit.cover)),
          child: GameScreen(ship: ship),
    ));
  }
}

class GameScreen extends StatefulWidget {
  final Ships ship;
  const GameScreen({super.key, required this.ship});

  @override
  _GameScreen createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  var game = Game();

  void gameEndNavigation(){
       Navigator.push(
        context,
          MaterialPageRoute(
            builder: (context) {
              return EndGameBackGround(whichWin: game.whichWin,);
            }
          )
       );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth - 250;
        double cellSize = availableWidth / (game.gridSize * 2);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const DefaultTextStyle(
                        style: TextStyle(color: Colors.black, fontSize: 40),
                        child: Text("Поле игрока"),
                      ),
                      Container(
                        width: cellSize * game.gridSize,
                        height: cellSize * game.gridSize,
                        color: Colors.black26.withOpacity(0.5),
                        child: Field(
                          gridSize: 10,
                          cellSize: cellSize,
                          ships: widget.ship.ships,
                          hits: game.hitsEnemy,
                          playerRecognition: true,
                          onCellTap: (index) {
                            if (game.turn) {
                              setState(() {
                                game.turnCheck(index, widget.ship, false);
                                if (game.gameEndFlag) {
                                  gameEndNavigation();
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const DefaultTextStyle(
                        style: TextStyle(color: Colors.black, fontSize: 40),
                        child: Text("Поле противника"),
                      ),
                      Container(
                        width: cellSize * game.gridSize,
                        height: cellSize * game.gridSize,
                        color: Colors.black26.withOpacity(0.5),
                        child: Field(
                          gridSize: 10,
                          cellSize: cellSize,
                          ships: widget.ship.shipsEnemy,
                          hits: game.hits,
                          playerRecognition: false,
                          onCellTap: (index) {
                            if (!game.turn) {
                              setState(() {
                                game.turnCheck(index, widget.ship, true);
                                if (game.gameEndFlag) {
                                  gameEndNavigation();
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  GridCell({
    super.key,
    required this.index,
    required this.size,
    required this.isShip,
    required this.isHit,
    required this.playerRecognition,
    required this.onTap,
  });

  var field = FieldLogic();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.2),
          color: field.getCellColor(isHit, isShip, playerRecognition),
        ),
      ),
    );
  }
}


class EndGameBackGround extends StatelessWidget {
  final bool whichWin;
  const EndGameBackGround({super.key, required this.whichWin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/BattleShip.jpg"), fit: BoxFit.cover)),
      child: EndGameScreen(whichWin: whichWin,),
      )
    );
  }
}

class EndGameScreen extends StatelessWidget {
  final bool whichWin;
  const EndGameScreen({super.key, required this.whichWin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        child: Center(
          child: Text(
            whichWin ? 'Вы выиграли!': 'Вы проиграли.   :(', 
            style: const TextStyle(color: Colors.black, 
              fontSize: 100),
          ),
        ),
      )
    );
  }
}