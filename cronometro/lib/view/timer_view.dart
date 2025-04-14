import 'package:cronometro/util/constants.dart';
import 'package:cronometro/viewmodel/timer_viewmodel.dart';
import 'package:cronometro/widgets/botoes.dart';
import 'package:cronometro/widgets/card_volta.dart';
import 'package:cronometro/widgets/circulo_progresso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerViewmodel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cronômetro"),
          actions: [
            //Botão para alternar entre os temas
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: () {
                TemaModifier.toggleTheme(
                  Theme.of(context).brightness == Brightness.light,
                );
              },
            )
          ],
        ),
        body: Center(
          child: Consumer<TimerViewmodel>(builder: (context, tempo, child) {
            print(
                "Consumer rebuild: isRunning = ${tempo.isRunning}, segundos = ${tempo.seconds}");
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: tempo.progresso == 0.0
                      ? "Cronômetro zerado"
                      : "Cronômetro em andamento",
                  hint: tempo.progresso == 0.0
                      ? "Cronômetro zerado"
                      : "Tempo decorrido ${_formatarTempo(tempo.seconds)}",
                  child:
                      //Contador
                      Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ProgressCircle(progresso: tempo.progresso),
                        Text(
                          _formatarTempo(tempo.seconds),
                          style: const TextStyle(fontSize: 48),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  //Botões de controle
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Botão para iniciar o cronômetro
                        BotaoIconeTexto(
                          icon: Icons.play_arrow,
                          text: 'Iniciar',
                          onPressed:
                              tempo.isRunning ? null : () => tempo.startTimer(),
                          semanticsLabel: 'Botão Iniciar',
                          semanticsHint: 'Inicia o cronômetro',
                        ),
                        //Botão para adicionar volta
                        const SizedBox(width: 10),
                        BotaoIconeTexto(
                          icon: Icons.restore,
                          text: 'Volta',
                          onPressed:
                              tempo.isRunning ? () => tempo.addVolta() : null,
                          semanticsLabel: 'Botão de Volta',
                          semanticsHint: 'Contabiliza a volta e o tempo dela',
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Botão para pausar o cronômetro
                        BotaoIconeTexto(
                          icon: Icons.pause_circle,
                          text: 'Pausar',
                          onPressed:
                              tempo.isRunning ? () => tempo.stopTimer() : null,
                          semanticsLabel: 'Botão Pausar',
                          semanticsHint: 'Pausa o cronômetro',
                        ),
                        //Botão para resetar o cronômetro
                        const SizedBox(width: 10),
                        BotaoIconeTexto(
                          icon: Icons.stop_circle,
                          text: 'Resetar',
                          onPressed: tempo.seconds != 0
                              ? tempo.isRunning
                                  ? null
                                  : () => tempo.resetTimer()
                              : null,
                          semanticsLabel: 'Botão Resetar',
                          semanticsHint: 'Zera o cronômetro e as voltas',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 370,
                      width: 300,
                      child: ListView.builder(
                        itemCount: tempo.voltas.length,
                        itemBuilder: (context, index) {
                          final tempoVolta = tempo.voltas[index];
                          //Calcula o tempo isolado da volta
                          final tempoVoltaAnterior =
                              index == 0 ? 0 : tempo.voltas[index - 1];
                          final tempoVoltaIsolado =
                              tempoVolta - tempoVoltaAnterior;
                          return CardVolta(
                            numeroVolta: index + 1,
                            tempoVolta: _formatarTempo(tempoVoltaIsolado),
                            tempoTotal: _formatarTempo(tempoVolta),
                            semanticsLabel: 'Volta ${index + 1}',
                            semanticsHint:
                                'Volta ${index + 1}, tempo de volta $tempoVoltaIsolado, tempo total $tempoVolta',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _formatarTempo(int segundos) {
    int horas = segundos ~/ 3600;
    int minutos = (segundos % 3600) ~/ 60;
    int segundosRestantes = segundos % 60;

    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segundosRestantes.toString().padLeft(2, '0')}';
  }
}
