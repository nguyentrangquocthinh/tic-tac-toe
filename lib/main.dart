import 'package:flutter/material.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // declare variables
  bool oTurns = true;

  // 1st player is O
  List<String> oList = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Column (
        children: <Widget>[
          Expanded(

           // * create score board

          child: Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30.0),
                      child: Column (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Player X',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            xScore.toString(),
                            style:  const TextStyle(
                              fontSize: 20,
                              color: Colors.white),
                          ),
                        ],
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Player O',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        oScore.toString(),
                        style:  const TextStyle(
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  ),
              )
            ],
          )
      ),

          // * create board for game
          Expanded(
            flex: 4,
            child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container (
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white)),
                      child: Center (
                        child: Text(
                          oList[index],
                          style: const TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                    ),
                  );
                }),
          ),

          Expanded(
          //   * button to clear score board
            child: Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[50], // màu nền của nút
                    foregroundColor: Colors.black,
                  ),
                    onPressed: _resetGame,
                    child: const Text("Clear Score Board")
                ),
              ],
            ))
        ],
      ),
    );
  }

  // * filling the boxes when tapped with X or O respectively
  void _tapped (int index) {
    setState(() {
      if (oTurns && oList[index] == '') {
        oList[index] = 'O';
        filledBoxes++;
      } else if (!oTurns && oList[index] == '') {
        oList[index] = 'X';
        filledBoxes++;
      }

      oTurns = !oTurns; // changed turn
      _checkWinner();
    });
  }

//   * checking winner function
    void _checkWinner() {
      String? winner = _checkRows() ?? _checkColumns() ?? _checkDiagonals();

      if (winner != null) {
        _showWinnerDialog(winner);
      } else if (filledBoxes == 9) {
        _showDrawDialog();
      }
    }

//      checking rows
    String? _checkRows() {
      for (int i = 0; i < 3; i++) {
        if (oList[i * 3] == oList[i * 3 + 1] &&
            oList[i * 3] == oList[i * 3 + 2] &&
            oList[i * 3] != '') {
          return oList[i * 3];
        }
      }
      return null;
    }

//       checking columns
    String? _checkColumns() {
      for (int i = 0; i < 3; i++) {
        if (oList[i] == oList[i + 3] &&
            oList[i] == oList[i + 6] &&
            oList[i] != '') {
          return oList[i];
        }
      }
      return null;
    }

//      checking diagonal
    String? _checkDiagonals() {
      if (oList[0] == oList[4] &&
          oList[0] == oList[8] &&
          oList[0] != '') {
        return oList[0];
      } else if (oList[2] == oList[4] &&
                 oList[2] == oList[6] &&
                 oList[2] != '') {
        return oList[2];
      }
      return null;  
    }

//      show winner dialog
  void _showWinnerDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("\" $winner \" is the winner!!!"),
            actions: <Widget>[
            TextButton(
                onPressed: () {
                  _resetGame();
                  Navigator.of(context).pop();
                },
                child: const Text("Play again"))
            ],
          );
        });

    if (winner == 'O') {
      oScore++;
    }  else if (winner == 'X') {
      xScore++;
    }
  }

//    show draw dialog
  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Draw!"),
            content: const Text("It's a draw"),
            actions: <Widget>[
              TextButton(
                  child: const Text("Play again"),
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
              ),
            ],
          );
        }
    );
  }

//   reset game
  void _resetGame() {
    setState(() {
      oList = ['', '', '', '', '', '', '', '', ''];
      filledBoxes = 0;
      oTurns = true;
    });
  }

}


