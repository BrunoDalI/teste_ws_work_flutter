import 'package:flutter/material.dart';
import '../bloc/lead_sync_state.dart';

class SyncStatusCard extends StatelessWidget {
  final LeadSyncState state;

  const SyncStatusCard({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.sync, size: 48, color: Color(0xFF191244)),
          const SizedBox(height: 16),
          Text(
            'Status da Sincronização',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF191244),
            ),
          ),
          const SizedBox(height: 8),
          _buildStatusContent(context),
        ],
      ),
    );
  }

  Widget _buildStatusContent(BuildContext context) {
    if (state is LeadSyncLoading) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Carregando...'),
        ],
      );
    } else if (state is LeadSyncLoaded) {
      final loadedState = state as LeadSyncLoaded;
      final unsent = loadedState.unsentLeads.length;
      final allSynced = unsent == 0;

      return Column(
        children: [
          Text(
            '$unsent leads pendentes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: allSynced ? Colors.green[600] : Colors.orange[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            allSynced
                ? 'Todos os leads foram sincronizados'
                : 'Toque em "Sincronizar Leads" para enviar os leads pendentes',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (state is LeadSyncSending) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Enviando leads...'),
        ],
      );
    } else if (state is LeadSyncError) {
      final errorState = state as LeadSyncError;

      return Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 32),
          const SizedBox(height: 8),
          Text(
            'Erro na sincronização',
            style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            errorState.message,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
