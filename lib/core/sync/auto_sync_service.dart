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

  AutoSyncService({
    required this.getUnsentLeads,
    required this.sendLeads,
    required this.leadRepository,
  });

  bool get isEnabled => _enabled;
  Duration? get interval => _interval;
  DateTime? get nextRunAt => _nextAt;

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
    await result.fold((_) async {}, (leads) async {
      if (leads.isEmpty) return;
      final sendRes = await sendLeads(SendLeadsParams(leads: leads));
      await sendRes.fold((_) async {}, (_) async {
        for (final lead in leads) {
          if (lead.id != null) {
            await leadRepository.markLeadAsSent(lead.id!);
          }
        }
      });
    });
    // schedule next
    if (_interval != null) {
      _nextAt = DateTime.now().add(_interval!);
    }
  }

  Future<void> dispose() async { disable(); }
}