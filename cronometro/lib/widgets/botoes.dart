import 'package:flutter/material.dart';

class BotaoIconeTexto extends StatelessWidget {
  //Atributos do Botão
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  //Atributos do Semantics
  final String semanticsLabel;
  final String semanticsHint;

  const BotaoIconeTexto({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.color,
    required this.semanticsLabel,
    required this.semanticsHint,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 180,
      child: Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        button: true,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
