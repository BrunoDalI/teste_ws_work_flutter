import 'package:flutter/material.dart';
import '../bloc/lead_sync_state.dart';

/// Minimal, clean list of unsent leads.
/// Parent (page) is responsible for providing height constraints (e.g. wrapping in Expanded).
class UnsentLeadsList extends StatelessWidget {
  final LeadSyncLoaded state;
  final bool expand; // if true wrap with Expanded automatically
  const UnsentLeadsList({super.key, required this.state, this.expand = false});

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (state.unsentLeads.isEmpty) {
      body = const _EmptyState();
    } else {
      body = Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Leads Pendentes (${state.unsentLeads.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF191244),
                    ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: state.unsentLeads.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final lead = state.unsentLeads[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: Icon(Icons.person, color: Colors.orange[700]),
                    ),
                    title: Text(
                      lead.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.userEmail, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(
                            '${lead.carModel} - ${lead.formattedCarValue}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(Icons.sync_problem, color: Colors.orange[600]),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (expand) return Expanded(child: body);
    return body;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.green[500]),
          const SizedBox(height: 12),
          Text(
            'Nenhum lead pendente',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Todos foram sincronizados.',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
