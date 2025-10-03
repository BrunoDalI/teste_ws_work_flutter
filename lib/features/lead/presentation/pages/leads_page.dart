import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/custom_appbar_widget.dart';
import '../../../../core/widgets/error_message_widget.dart';
import '../../../../core/widgets/gradient_background_widget.dart';
import '../../../../core/widgets/loading_message_widget.dart';
import '../bloc/lead_bloc.dart';
import '../widgets/lead_card.dart';

/// Page for displaying all leads
class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<LeadBloc>()..add(const LoadLeadsEvent()),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Clientes Interessados', backgroundColor: Colors.green[600]!),
        body: SafeArea(
          child: GradientBackground(
            colors: [Colors.green[600]!, Colors.white],
            stops: const [0.0, 0.3],
            child: BlocBuilder<LeadBloc, LeadState>(
              builder: (context, state) {
                if (state is LeadLoading) {
                  return const LoadingMessage(message: 'Carregando clientes...');
                } else if (state is LeadsLoaded) {
                  if (state.leads.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum cliente interessado ainda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Os interessados em carros aparecerão aqui',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
          
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: state.leads.length,
                    itemBuilder: (context, index) {
                      final lead = state.leads[index];
                      return LeadCard(lead: lead);
                    },
                  );
                } else if (state is LeadError) {
                  return ErrorMessage(
                    title: 'Erro ao carregar clientes',
                    message: state.message,
                    onRetry: () => context.read<LeadBloc>().add(const LoadLeadsEvent()),
                    color: Colors.green,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
