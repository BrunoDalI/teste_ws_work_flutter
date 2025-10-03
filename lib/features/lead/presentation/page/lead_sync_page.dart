import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/custom_appbar_widget.dart';
import '../../domain/usecases/get_unsent_leads.dart';
import '../../domain/usecases/send_leads.dart';
import '../../domain/repositories/lead_repository.dart';
import '../bloc/lead_sync_bloc.dart';
import '../bloc/lead_sync_event.dart';
import '../bloc/lead_sync_state.dart';

/// Page for managing lead synchronization
class LeadSyncPage extends StatelessWidget {
  const LeadSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeadSyncBloc(
        getUnsentLeads: di.sl<GetUnsentLeads>(),
        sendLeads: di.sl<SendLeads>(),
        leadRepository: di.sl<LeadRepository>(),
      )..add(const LoadUnsentLeadsEvent()),
      child: const Scaffold(
        appBar: CustomAppBar(
          title: 'Sincronização de Leads',
          backgroundColor: Color.fromARGB(255, 117, 104, 31),
        ),
        body: _LeadSyncBody(),
      ),
    );
  }
}

class _LeadSyncBody extends StatelessWidget {
  const _LeadSyncBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 117, 104, 31),
              Colors.white
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: BlocConsumer<LeadSyncBloc, LeadSyncState>(
          listener: (context, state) {
            if (state is LeadSyncSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('${state.syncedCount} lead(s) sincronizado(s) com sucesso!'),
                    ],
                  ),
                  backgroundColor: Colors.green[600],
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is LeadSyncError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Erro: ${state.message}')),
                    ],
                  ),
                  backgroundColor: Colors.red[600],
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildStatusCard(context, state),
                const SizedBox(height: 20),
                _buildActionButtons(context, state),
                const SizedBox(height: 20),
                if (state is LeadSyncLoaded) 
                  _buildLeadsList(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, LeadSyncState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sync,
            size: 48,
            color: Color(0xFF191244),
          ),
          const SizedBox(height: 16),
          Text(
            'Status da Sincronização',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF191244),
            ),
          ),
          const SizedBox(height: 8),
          if (state is LeadSyncLoading)
            const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Carregando...'),
              ],
            )
          else if (state is LeadSyncLoaded)
            Column(
              children: [
                Text(
                  '${state.unsentLeads.length} leads pendentes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: state.unsentLeads.isEmpty 
                        ? Colors.green[600] 
                        : Colors.orange[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.unsentLeads.isEmpty
                      ? 'Todos os leads foram sincronizados'
                      : 'Toque em "Sincronizar Leads" para enviar os leads pendentes',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else if (state is LeadSyncSending)
            const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Enviando leads...'),
              ],
            )
          else if (state is LeadSyncError)
            Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Erro na sincronização',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LeadSyncState state) {
    final canSync = state is LeadSyncLoaded && state.unsentLeads.isNotEmpty;
    final isLoading = state is LeadSyncLoading || state is LeadSyncSending;

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
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(
                isLoading ? 'Sincronizando...' : 'Sincronizar Leads',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF191244),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: !isLoading
                  ? () => context.read<LeadSyncBloc>().add(const LoadUnsentLeadsEvent())
                  : null,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Atualizar Lista',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF191244),
                side: const BorderSide(color: Color(0xFF191244)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsList(BuildContext context, LeadSyncLoaded state) {
    if (state.unsentLeads.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum lead pendente!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Todos os leads foram sincronizados com a WSWork.',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Leads Pendentes (${state.unsentLeads.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF191244),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: state.unsentLeads.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final lead = state.unsentLeads[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: Icon(
                        Icons.person,
                        color: Colors.orange[600],
                      ),
                    ),
                    title: Text(
                      lead.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead.userEmail),
                        Text(
                          '${lead.carModel} - ${lead.formattedCarValue}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.sync_problem,
                      color: Colors.orange[600],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}