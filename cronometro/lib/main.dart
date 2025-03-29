import 'package:cronometro/util/constants.dart';
import 'package:cronometro/view/timer_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TemaModifier.instance,
      builder: (context, modoTema, child){
        return MaterialApp(
          title: 'Cronômetro',
          themeMode: modoTema,
          theme: Temas.lightTheme,
          darkTheme: Temas.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const TimerView(),
        );
      },
    );
  }
}
