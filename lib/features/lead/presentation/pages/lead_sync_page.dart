import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/helpers/show_snackbar_helpers.dart';
import '../../../../core/widgets/custom_appbar_widget.dart';
import '../../../../core/widgets/gradient_background_widget.dart';
import '../../domain/usecases/get_unsent_leads.dart';
import '../../domain/usecases/send_leads.dart';
import '../../domain/repositories/lead_repository.dart';
import '../bloc/lead_sync_bloc.dart';
import '../bloc/lead_sync_event.dart';
import '../bloc/lead_sync_state.dart';
import '../widgets/sync_action_buttons.dart';
import '../widgets/sync_status_card.dart';
import '../widgets/unsent_leads_list.dart';

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
        autoSyncService: di.sl(),
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
      child: GradientBackground(
        colors: const [Color.fromARGB(255, 117, 104, 31), Colors.white],
        stops: const [0.0, 0.3],
        child: BlocConsumer<LeadSyncBloc, LeadSyncState>(
          listener: (context, state) {
            if (state is LeadSyncSuccess) {
              showAppSnackBar(
                context,
                message: '${state.syncedCount} lead(s) sincronizado(s) com sucesso!',
                backgroundColor: Colors.green[600]!,
                icon: Icons.check_circle,
              );
            } else if (state is LeadSyncError) {
              showAppSnackBar(
                context,
                message: 'Erro: ${state.message}',
                backgroundColor: Colors.red[600]!,
                icon: Icons.error,
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SyncStatusCard(state: state),
                const SizedBox(height: 20),
                SyncActionButtons(state: state),
                const SizedBox(height: 20),
                if (state is LeadSyncLoaded) UnsentLeadsList(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}