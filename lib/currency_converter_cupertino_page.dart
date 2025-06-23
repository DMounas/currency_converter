import 'package:flutter/cupertino.dart';

class CurrencyConverterCupertinoPage extends StatefulWidget {
  const CurrencyConverterCupertinoPage({super.key});

  @override
  State<CurrencyConverterCupertinoPage> createState() =>
      _CurrencyConverterCupertinoPageState();
}

class _CurrencyConverterCupertinoPageState
    extends State<CurrencyConverterCupertinoPage> {
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  void convert() {
    result = double.parse(textEditingController.text) * 86;
    setState(() {});
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(255, 2, 30, 58),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(255, 2, 30, 58),
        middle: Text(
          "Currency Converter App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          selectionColor: Color.fromARGB(255, 46, 255, 255),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INR ${result != 0 ? result.toStringAsFixed(3) : result.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(46, 255, 255, 1),
                ),
              ),
              CupertinoTextField(
                controller: textEditingController,
                style: const TextStyle(
                    color: Color.fromRGBO(18, 18, 173, 1),
                    fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemCyan,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                placeholder: "Please enter the amount in USD",
                prefix: Icon(CupertinoIcons.money_dollar),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                onPressed: convert,
                color: (Color.fromRGBO(46, 255, 255, 1)),
                minimumSize: Size(double.infinity, 45),
                child: Text("Convert"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
