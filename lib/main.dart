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