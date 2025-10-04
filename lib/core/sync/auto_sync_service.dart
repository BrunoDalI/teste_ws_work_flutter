import 'dart:async';
import '../../features/lead/domain/usecases/get_unsent_leads.dart';
import '../../features/lead/domain/usecases/send_leads.dart';
import '../../features/lead/domain/repositories/lead_repository.dart';

class AutoSyncService {
  final GetUnsentLeads getUnsentLeads;
  final SendLeads sendLeads;
  final LeadRepository leadRepository;

  Timer? _timer;
  Duration? _interval;
  bool _enabled = false;
  DateTime? _nextAt;
  final _resultController = StreamController<AutoSyncResult>.broadcast();

  AutoSyncService({
    required this.getUnsentLeads,
    required this.sendLeads,
    required this.leadRepository,
  });

  bool get isEnabled => _enabled;
  Duration? get interval => _interval;
  DateTime? get nextRunAt => _nextAt;
  Stream<AutoSyncResult> get results => _resultController.stream;

  void enable(Duration interval) {
    _interval = interval;
    _enabled = true;
    _timer?.cancel();
    _nextAt = DateTime.now().add(interval);
    _timer = Timer.periodic(interval, (_) => _tick());
  }

  void disable() {
    _enabled = false;
    _interval = null;
    _nextAt = null;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    if (!_enabled) return;
    final result = await getUnsentLeads();
    int sent = 0;
    await result.fold((_) async {}, (leads) async {
      if (leads.isEmpty) return;
      final sendRes = await sendLeads(SendLeadsParams(leads: leads));
      await sendRes.fold((_) async {}, (_) async {
        for (final lead in leads) {
          if (lead.id != null) {
            await leadRepository.markLeadAsSent(lead.id!);
            sent++;
          }
        }
      });
    });
    if (sent > 0) {
      _resultController.add(AutoSyncResult(sentCount: sent, timestamp: DateTime.now()));
    }

    if (_interval != null) {
      _nextAt = DateTime.now().add(_interval!);
    }
  }

  Future<void> dispose() async { disable(); }
}

class AutoSyncResult {
  final int sentCount;
  final DateTime timestamp;
  AutoSyncResult({required this.sentCount, required this.timestamp});
}

/*
Resumo (AutoSyncService):
Serviço responsável por sincronização periódica dos leads não enviados. Mantém estado interno
(timer, próximo horário de execução e flag enabled) e expõe um stream broadcast de resultados
para que múltiplos listeners (ex: páginas ou bloc) reajam. A estratégia é simples:
1. enable(interval) agenda Timer.periodic.
2. Em cada tick busca leads pendentes, tenta enviar em lote e marca como enviados.
3. Emite AutoSyncResult somente quando houve pelo menos 1 lead enviado.
4. Atualiza a previsão de próxima execução (nextRunAt) para exibir feedback ao usuário.
Decisão: evitar dependência em BLoC aqui para manter reuso em camadas distintas e facilitar testes
unitários isolados.
*/