import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  // ignore: constant_identifier_names
  static const String PLAYER_X = "X";
  // ignore: constant_identifier_names
  static const String PLAYER_O = "O";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;
  late int scoreX = 0;
  late int scoreO = 0;

  @override
  void initState() {
    initializeGame();
    restartScore();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //for the 9 squares
  }

  void restartScore() {
    scoreX = 0;
    scoreO = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textHeader(),
            gameBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                restartButton(),
                scoresRestart(),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget textHeader() {
    return Column(
      children: [
        const Text(
          'Tic Tac Toe',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentPlayer turn",
          style: const TextStyle(color: Colors.grey,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Player X: $scoreX | Player O: $scoreO",
          style: const TextStyle(color: Colors.grey,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget gameBox() {
    return Container(
      height: MediaQuery.sizeOf(context).height / 2,
      width: MediaQuery.sizeOf(context).height / 2,
      //by calling MediaQuery.sizeOf(context) the widget will rebuild
      //only when the size changes, avoiding unnecessary rebuilds
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, int index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        //on click to the box

        if (gameEnd || occupied[index].isNotEmpty) {
          //Returning when the game is ended or the box is already clicked
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changedTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == PLAYER_X
                ? Colors.blue
                : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(occupied[index], style: const TextStyle(fontSize: 50)),
        ),
      ),
    );
  }

  Widget restartButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            gameEnd = false;
            occupied = ["", "", "", "", "", "", "", "", ""];
            changedTurn();
          });
        },
        child: const Text(
          'Restart The Boxes',
        ),
    );
  }

  Widget scoresRestart() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          restartScore();
        });
      },
      child: const Text(
        'Restart Score',
      ),
    );
  }

  changedTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_O;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  checkForWinner() {
    //defining the winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          //if they are all equal it means the player won
          showGameOverMessage("Player $playerPosition0 won");

          if(playerPosition0 == PLAYER_X){
            scoreX++;
          }if(playerPosition0 == PLAYER_O){
            scoreO++;
          }

          gameEnd = true;
          return;
        }
      }
    }
  }

  checkForDraw() {
    if(gameEnd){
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        //if at least one is empty not all are filled
        draw = false;
      }
    }

    if(draw){
      showGameOverMessage('Draw');
      gameEnd = true;
    }

  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.teal,
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
