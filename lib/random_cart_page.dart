import 'dart:async'; // Import for Timer
import 'dart:math';

import 'package:deck_of_cards/custom_button.dart';
import 'package:flutter/material.dart';

import 'card_list.dart';

class RandomCardPage extends StatefulWidget {
  @override
  _RandomCardPageState createState() => _RandomCardPageState();
}

class _RandomCardPageState extends State<RandomCardPage> {
  PlayingCard? _currentCard; // To store the current card object
  Timer? _timer; // Timer object
  int _elapsedTime = 0; // Time in seconds

  List<PlayingCard> _currentDeckToGo = [];
  List<PlayingCard> _currentDeckDone = [];
  int _cardsDone = 0;
  int _cardsToGo = 0;
  int _totalCards = 0;
  int _repsDone = 0;
  final int _totalReps =
      cardList.fold(0, (sum, card) => sum + int.parse(card.value));
  bool _isDone = false; // Track if the deck is done
  bool _isLastCard = false;

  void _showRandomCard() {
    final random = Random();
    final randomIndex = random.nextInt(cardList.length);

    setState(() {
      _currentCard = cardList[randomIndex];
    });
  }

  void _goThroughDeck() {
    final random = Random();
    final randomIndex = random.nextInt(_currentDeckToGo.length);
    final newCard = _currentDeckToGo[randomIndex];
    _repsDone += int.parse(_currentCard?.value ?? '0');

    setState(() {
      _currentDeckToGo.removeAt(randomIndex);
      _currentDeckDone.add(newCard);
      _cardsDone++;
      _cardsToGo--;
      _currentCard = newCard;
    });

    if (_currentDeckToGo.isEmpty) {
      setState(() {
        _isLastCard = true;
      });
      return;
    }
  }

  void _startNewDeck() {
    setState(() {
      _currentDeckToGo = List.from(cardList); // Create a copy
      _currentDeckDone = [];
      _cardsDone = 0;
      _cardsToGo = cardList.length;
      _totalCards = cardList.length;
      _repsDone = 0;
      _elapsedTime = 0; // Reset elapsed time
      _isDone = false; // Reset deck status
      _isLastCard = false;
    });

    _goThroughDeck();

    // Start or reset the timer
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startNewDeck(); // Start new deck when the screen opens
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _showRestartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restart Deck'),
          content: Text('Are you sure you want to restart the deck?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _startNewDeck(); // Restart the deck
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F7), // Set background color
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F7), // Set background color
        title: Text('Deck Of Cards', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed:
                _showRestartDialog, // Show restart dialog on button press
            tooltip: 'Start New Deck',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PlayingCard count display
            Text(
              _formatTime(_elapsedTime),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 30), // Space between the buttons
            Text(
              '$_cardsDone / $_totalCards',
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 40,
                  height: 1,
                  color: Colors.black),
            ),
            SizedBox(height: 10), // Space between the buttons
            Text(
              'Reps: $_repsDone / $_totalReps',
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 30,
                  height: 1,
                  color: Colors.black),
            ),
            SizedBox(height: 10), // Space between the buttons
            Text(
              'Cards left: $_cardsToGo',
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 30,
                  height: 1,
                  color: Colors.black),
            ),
            SizedBox(height: 10), // Space between the buttons
            // Display the card image
            if (_currentCard != null)
              Image.asset(
                _currentCard!.url,
                /*  height: 500, // Adjust height as needed
                width: 300, */
              )
            else
              Text('Press the button to draw a card!'),

            // Display the card value
            if (_currentCard?.value != null)
              Text(
                "${_currentCard?.value}",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.black),
              ),

            SizedBox(height: 20), // Space between the card value and buttons

            // Draw Random PlayingCard Button
            /*  ElevatedButton(
              onPressed: _currentDeckToGo.isEmpty ? null : _goThroughDeck,
              child: Text('Draw Random Card'),
            ), */
            if (!_isLastCard)
              CustomButton(
                onPressed: _currentDeckToGo.isEmpty ? null : _goThroughDeck,
                text: 'DRAW RANDOM',
              ),
            SizedBox(height: 10), // Space between the buttons

            // DONE Button or WELL DONE message
            if (_isDone)
              Text(
                'WELL DONE!!!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )
            else if (_isLastCard)
              CustomButton(
                onPressed: _cardsToGo == 0
                    ? () {
                        setState(() {
                          _isDone = true;
                          _timer?.cancel(); // Stop the timer
                        });
                      }
                    : null,
                text: 'DONE',
              ),
          ],
        ),
      ),
    );
  }
}
