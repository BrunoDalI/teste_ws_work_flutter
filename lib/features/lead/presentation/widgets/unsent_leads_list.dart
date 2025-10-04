import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lead_sync_bloc.dart';
import '../bloc/lead_sync_event.dart';
import '../bloc/lead_sync_state.dart';

class UnsentLeadsList extends StatelessWidget {
  final LeadSyncLoaded state;

  const UnsentLeadsList({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    if (state.unsentLeads.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.green[400]),
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
                'Todos os leads foram sincronizados.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        key: const Key('leadSyncRefreshIndicator'),
        onRefresh: () async {
          context.read<LeadSyncBloc>().add(const LoadUnsentLeadsEvent());
        },
        child: Container(
          margin: const EdgeInsets.all(16),
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
                        child: Icon(Icons.person, color: Colors.orange[600]),
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
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.sync_problem, color: Colors.orange[600]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
