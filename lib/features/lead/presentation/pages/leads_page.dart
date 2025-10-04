import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/custom_appbar_widget.dart';
import '../../../../core/widgets/error_message_widget.dart';
import '../../../../core/widgets/gradient_background_widget.dart';
import '../../../../core/widgets/loading_message_widget.dart';
import '../../../../core/sync/auto_sync_service.dart';
import '../bloc/lead_bloc.dart';
import '../widgets/empty_leads_message.dart';
import '../widgets/lead_card.dart';

/// Page for displaying all leads
class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  AutoSyncService? _autoSyncService;
  StreamSubscription? _autoSyncSub;
  LeadBloc? _leadBloc; // torna nullable para evitar LateInitializationError em hot reload

  @override
  void initState() {
    super.initState();
    // Cria o bloc aqui (antes do build) para poder usar no listener sem depender de context ancestor
  _leadBloc = di.sl<LeadBloc>()..add(const LoadLeadsEvent());
    // Atraso para garantir que DI já foi inicializado completamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _autoSyncService = di.sl<AutoSyncService>();
        _autoSyncSub = _autoSyncService!.results.listen((_) {
          if (mounted) {
            _leadBloc?.add(const LoadLeadsEvent());
          }
        });
      } catch (_) {
        // Ignora se serviço não estiver registrado (ex: testes)
      }
    });
  }

  @override
  void dispose() {
    _autoSyncSub?.cancel();
  _leadBloc?.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Garante instancia (em casos raros de hot reload onde initState não reexecuta)
    _leadBloc ??= di.sl<LeadBloc>()..add(const LoadLeadsEvent());
    return BlocProvider.value(
      value: _leadBloc!,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Clientes Interessados', backgroundColor: Colors.green[600]!),
        body: SafeArea(
          child: GradientBackground(
            colors: [Colors.green[600]!, Colors.white],
            stops: const [0.0, 0.5],
            child: BlocBuilder<LeadBloc, LeadState>(
              builder: (context, state) {
                final width = MediaQuery.of(context).size.width;
                final bool isGrid = width >= 760;

                return RefreshIndicator(
                  key: const Key('leadsRefreshIndicator'),
                  onRefresh: () async => _leadBloc!.add(const LoadLeadsEvent()),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (state is LeadLoading)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: LoadingMessage(message: 'Carregando clientes...')),
                        )
                      else if (state is LeadError)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: ErrorMessage(
                              title: 'Erro ao carregar clientes',
                              message: state.message,
                              onRetry: () => _leadBloc!.add(const LoadLeadsEvent()),
                              color: Colors.green,
                            ),
                          ),
                        )
                      else if (state is LeadsLoaded && state.leads.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: EmptyLeadsMessage()),
                        )
                      else if (state is LeadsLoaded && !isGrid)
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          sliver: SliverList(
                            key: const Key('leadsListView'),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => LeadCard(lead: state.leads[index]),
                              childCount: state.leads.length,
                            ),
                          ),
                        )
                      else if (state is LeadsLoaded && isGrid)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          sliver: SliverGrid(
                            key: const Key('leadsGridView'),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.6,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => LeadCard(lead: state.leads[index]),
                              childCount: state.leads.length,
                            ),
                          ),
                        )
                      else
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
