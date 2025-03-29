class TimerModel {
  int _segundos = 0;
  List<int> _voltas = [];

  int get seconds => _segundos;

  void setSeconds(int segundos) {
    _segundos = segundos;
  }

  List<int> get voltas => _voltas;
  void tick() {
    _segundos++;
  }

  void addVolta(int tempoVolta) {
    _voltas.add(tempoVolta);
  }

  void reset() {
    _segundos = 0;
    _voltas.clear();
  }
}
