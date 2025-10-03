import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lead_sync_bloc.dart';
import '../bloc/lead_sync_event.dart';
import '../bloc/lead_sync_state.dart';

class SyncActionButtons extends StatelessWidget {
  final LeadSyncState state;

  const SyncActionButtons({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    bool canSync = false;
    bool isLoading = state is LeadSyncLoading || state is LeadSyncSending;

    Duration? selectedInterval;
    bool autoEnabled = false;
    DateTime? nextAt;

    if (state is LeadSyncLoaded) {
      final s = state as LeadSyncLoaded;
      canSync = s.unsentLeads.isNotEmpty;
      selectedInterval = s.autoSyncInterval;
      autoEnabled = s.autoSyncEnabled;
      nextAt = s.nextAutoSyncAt;
    } else if (state is LeadSyncSending) {
      final s = state as LeadSyncSending;
      selectedInterval = s.autoSyncInterval;
      autoEnabled = s.autoSyncEnabled;
      nextAt = s.nextAutoSyncAt;
    } else if (state is LeadSyncSuccess) {
      final s = state as LeadSyncSuccess;
      selectedInterval = s.autoSyncInterval;
      autoEnabled = s.autoSyncEnabled;
      nextAt = s.nextAutoSyncAt;
    }

    final intervals = <Duration>[
      const Duration(minutes: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 15),
    ];

    String formatDuration(Duration d) {
      if (d.inMinutes < 1) return '${d.inSeconds}s';
      return '${d.inMinutes} min';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: canSync && !isLoading
                ? () => context.read<LeadSyncBloc>().add(const SyncLeadsEvent())
                : null,
              icon: isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ) : const Icon(Icons.cloud_upload),
              label: Text(
                isLoading ? 'Sincronizando...' : 'Sincronizar Leads',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF191244),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: DropdownButtonFormField<Duration>(
          //         decoration: const InputDecoration(
          //           labelText: 'Intervalo Auto Sync',
          //           border: OutlineInputBorder(),
          //         ),
          //         initialValue: selectedInterval,
          //         items: intervals.map((d) => DropdownMenuItem(
          //           value: d,
          //           child: Text(formatDuration(d)),
          //         )).toList(),
          //         onChanged: (d) {
          //           if (d != null && autoEnabled) {
          //             context.read<LeadSyncBloc>().add(EnableAutoSyncEvent(d));
          //           }
          //         },
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Switch(
          //               value: autoEnabled,
          //               onChanged: (val) {
          //                 if (val) {
          //                   final interval = selectedInterval ?? intervals.first;
          //                   context.read<LeadSyncBloc>().add(EnableAutoSyncEvent(interval));
          //                 } else {
          //                   context.read<LeadSyncBloc>().add(const DisableAutoSyncEvent());
          //                 }
          //               },
          //             ),
          //             const Text('Auto'),
          //           ],
          //         ),
          //         if (autoEnabled && nextAt != null)
          //           Text(
          //             'Próx: ${nextAt.hour.toString().padLeft(2, '0')}:${nextAt.minute.toString().padLeft(2, '0')}:${nextAt.second.toString().padLeft(2, '0')}',
          //             style: const TextStyle(fontSize: 11, color: Colors.grey),
          //           ),
          //       ],
          //     ),
          //   ],
          // ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(255, 117, 104, 31).withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configurações de Auto Sync',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF191244),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Duration>(
                        decoration: InputDecoration(
                          labelText: 'Intervalo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        initialValue: selectedInterval,
                        items: intervals.map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(formatDuration(d)),
                        )).toList(),
                        onChanged: (d) {
                          if (d != null && autoEnabled) {
                            context.read<LeadSyncBloc>().add(EnableAutoSyncEvent(d));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: autoEnabled,
                              onChanged: (val) {
                                if (val) {
                                  final interval = selectedInterval ?? intervals.first;
                                  context.read<LeadSyncBloc>().add(EnableAutoSyncEvent(interval));
                                } else {
                                  context.read<LeadSyncBloc>().add(const DisableAutoSyncEvent());
                                }
                              },
                            ),
                            const Text('Auto', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        if (autoEnabled && nextAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Próx: ${nextAt.hour.toString().padLeft(2, '0')}:${nextAt.minute.toString().padLeft(2, '0')}:${nextAt.second.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }
}
