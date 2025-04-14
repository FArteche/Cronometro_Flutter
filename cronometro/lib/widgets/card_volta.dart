import 'package:flutter/material.dart';

class CardVolta extends StatelessWidget {
  //Atributos do Card
  final int numeroVolta;
  final String tempoVolta;
  final String tempoTotal;
  //Atributos do Semantics
  final String semanticsLabel;
  final String semanticsHint;

  const CardVolta({
    Key? key,
    required this.numeroVolta,
    required this.tempoVolta,
    required this.tempoTotal,
    required this.semanticsLabel,
    required this.semanticsHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$numeroVolta',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tempo da volta: $tempoVolta',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tempo total: $tempoTotal',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
