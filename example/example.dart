import 'package:flutter/material.dart';
import 'package:spinner_input_plus/spinner_input.dart';

void main() => runApp(const MySpinner());

class MySpinner extends StatefulWidget {
  const MySpinner({Key? key}) : super(key: key);

  @override
  MySpinnerState createState() => MySpinnerState();
}

class MySpinnerState extends State<MySpinner> {
  double spinner = 0;
  double spinner3 = -5;
  double spinner4 = 20;
  double spinner5 = 82.654;
  double spinner6 = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            // default spinner
            Container(
              margin: const EdgeInsets.all(20),
              child: SpinnerInput(
                spinnerValue: spinner,
                // minValue: 0,
                // maxValue: 200,
                onChange: (newValue) {
                  setState(() {
                    spinner = newValue;
                  });
                },
              ),
            ),

            // Set step ( can be int or double )
            Container(
              margin: const EdgeInsets.all(20),
              child: SpinnerInput(
                minValue: 0,
                maxValue: 200,
                step: 5,
                plusButton: SpinnerButtonStyle(
                  elevation: 0,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(0),
                ),
                minusButton: SpinnerButtonStyle(
                  elevation: 0,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(0),
                ),
                middleNumberWidth: 70,
                middleNumberStyle: const TextStyle(fontSize: 21),
                middleNumberBackground: Colors.yellowAccent.withOpacity(0.5),
                spinnerValue: spinner3,
                onChange: (newValue) {
                  setState(() {
                    spinner3 = newValue;
                  });
                },
              ),
            ),

            // Disable long press and input-popup
            Container(
              margin: const EdgeInsets.all(20),
              child: SpinnerInput(
                minValue: 0,
                maxValue: 200,
                disabledLongPress: true,
                disabledPopup: true,
                step: 5,
                spinnerValue: spinner4,
                onChange: (newValue) {
                  setState(() {
                    spinner4 = newValue;
                  });
                },
              ),
            ),

            // A little more customized buttons
            Container(
              margin: const EdgeInsets.all(20),
              child: SpinnerInput(
                minValue: 0,
                maxValue: 200,
                step: 5.524,
                fractionDigits: 3,
                plusButton: SpinnerButtonStyle(
                  color: Colors.green,
                  height: 60,
                  width: 60,
                  elevation: 1,
                  highlightElevation: 10,
                  child: const Icon(Icons.thumb_up),
                ),
                minusButton: SpinnerButtonStyle(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(0),
                ),
                spinnerValue: spinner5,
                onChange: (newValue) {
                  setState(() {
                    spinner5 = newValue;
                  });
                },
              ),
            ),

            // RTL support
            Container(
              margin: const EdgeInsets.all(50),
              child: SpinnerInput(
                direction: TextDirection.rtl,
                spinnerValue: spinner6,
                onChange: (newValue) {
                  setState(() {
                    spinner6 = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
