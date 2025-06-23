import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double _result = 0;
  final TextEditingController _textEditingController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  String _statusMessage = 'Enter an amount to convert';
  bool _isLoading = false;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR'
  ];

  void resetState() {
    setState(() {
      _textEditingController.clear();
      _result = 0;
      _statusMessage = 'Enter an amount to convert';
    });
  }

  Future<void> convert() async {
    if (_textEditingController.text.isEmpty) {
      setState(() {
        _result = 0;
        _statusMessage = 'Enter an amount to convert';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching rate...';
    });

    try {
      final amount = double.parse(_textEditingController.text);
      if (amount <= 0) {
        throw ArgumentError('Please enter a positive amount');
      }

      final url =
          'https://api.frankfurter.app/latest?amount=$amount&from=$_fromCurrency&to=$_toCurrency';
      final res = await http.get(Uri.parse(url));

      if (res.statusCode != 200) {
        throw Exception('Failed to load exchange rates');
      }

      final data = json.decode(res.body);
      final rate = data['rates'][_toCurrency];

      setState(() {
        _result = (rate as num).toDouble();
        _statusMessage = '$_fromCurrency to $_toCurrency Conversion';
      });
    } on ArgumentError catch (e) {
      setState(() {
        _statusMessage = e.message;
        _result = 0;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: Please enter a valid number';
        _result = 0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(width: 2, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 30, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 30, 58),
        elevation: 0,
        title: const Text(
          "Currency Converter",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: const Color.fromARGB(255, 46, 255, 255),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : resetState,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_toCurrency ${_result != 0 ? _result.toStringAsFixed(3) : _result.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(46, 255, 255, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _statusMessage,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textEditingController,
                style: const TextStyle(
                  color: Color.fromRGBO(18, 18, 173, 1),
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount in $_fromCurrency',
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(96, 117, 156, 1)),
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  prefixIconColor: const Color.fromRGBO(96, 117, 156, 1),
                  filled: true,
                  fillColor: const Color.fromRGBO(229, 245, 247, 1),
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCurrencyDropdown(
                    value: _fromCurrency,
                    onChanged: (newValue) {
                      setState(() {
                        _fromCurrency = newValue!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      setState(() {
                        final temp = _fromCurrency;
                        _fromCurrency = _toCurrency;
                        _toCurrency = temp;
                      });
                    },
                  ),
                  _buildCurrencyDropdown(
                    value: _toCurrency,
                    onChanged: (newValue) {
                      setState(() {
                        _toCurrency = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _isLoading ? null : convert,
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(46, 255, 255, 1),
                  foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text("Convert"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: _currencies.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      ),
    );
  }
}
