import 'package:flutter/material.dart';
import 'package:interactive_box_layout_app/core/color/colors.dart';
import 'package:provider/provider.dart';

import '../provider/box_layout_provider.dart';

/*

/// Example
N = 5

█ █
█
█ █


N = 8

█ █ █
█
█
█ █ █

/// Calculation

  limit N (between 5 and 25).
 
 if: n = 5 , then vertical 1 and horizontal 2 | 2
 if: n = 6 , then vertical ? and horizontal ? | ?
 .
 if: n = 8 , then vertical 2 and horizontal 3 | 3
 .
 .
 .
 if: n = 25 , then vertical ? and horizontal ? | ?


 from above example its seems the container are arrange in 2:1:2
 (2 horizontal) (1 vertical) ==> 
 8 = 3 : 2 : 3
 5 = 2 : 1 : 2

 in first example :
      top = 2
      middle = 1
      bottom = 2

in second example :
      top = 3
      middle = 2
      bottom = 3

  based on this 

  assume n = 6
  divide n by 2:1:2
  total 5 part 

  6/5 = 1.2

  top = 2 * 1.2.   = 2.4
  middle = 1 * 1.2 = 1.2
  bottom = 2 * 1.2 = 2.4

  rounded 2 : 2 : 2


  assume n = 25
  divide n by 2:1:2
  total 5 part

  25/5 = 5


  top = 2 * 5    = 10
  middle = 1 * 5 = 5
  bottom = 2 * 5 = 10

  rounded 10 : 5 : 10

*/

class InteractiveLayoutPage extends StatefulWidget {
  const InteractiveLayoutPage({super.key});

  @override
  State<InteractiveLayoutPage> createState() => _InteractiveLayoutPageState();
}

class _InteractiveLayoutPageState extends State<InteractiveLayoutPage> {
  final TextEditingController _controller = TextEditingController();

  /// Formkey for input feild validation
  final _formKey = GlobalKey<FormState>();

  List<Widget> _buildCBoxes() {
    if (context.watch<BoxLayoutProvider>().userInput == null) return [];

    final generatedcount = context
        .read<BoxLayoutProvider>()
        .generateBoxCounts();
    int topCount = generatedcount.$1;
    int middleCount = generatedcount.$2;
    int bottomCount = generatedcount.$3;
    List<Widget> children = [];
    int index = 0;

    /// Top Row
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(topCount, (_) {
          return _buildContainer(index++);
        }),
      ),
    );

    /// Middle Vertical
    children.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(middleCount, (_) {
          return _buildContainer(index++);
        }),
      ),
    );

    /// Bottom Row
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(bottomCount, (_) {
          return _buildContainer(index++);
        }),
      ),
    );

    return children;
  }

  /// Build container
  Widget _buildContainer(int index) {
    return GestureDetector(
      onTap: () => context.read<BoxLayoutProvider>().updateContainerTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        width: 25,
        height: 25,
        color: context.watch<BoxLayoutProvider>().boxStates[index]
            ? AppColor.tapColor
            : AppColor.activeColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Box Layout')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 500,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      /// Textfield to receive the user input
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter input number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the input number';
                            }
                            int userInputNumber = int.parse(value);
                            if (userInputNumber < 5 || userInputNumber > 25) {
                              return 'Number should be in between 5 to 25';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// Button to validate and Generate containers
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final inputValue = int.tryParse(_controller.text);
                            if (inputValue != null) {
                              context
                                  .read<BoxLayoutProvider>()
                                  .initializeContainerDetails(inputValue);
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (context.watch<BoxLayoutProvider>().userInput != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildCBoxes(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// dispose to avoid memmory leak
    _controller.dispose();
    super.dispose();
  }
}
