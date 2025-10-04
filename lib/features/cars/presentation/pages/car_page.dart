import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/helpers/show_snackbar_helpers.dart';
import '../../../../core/helpers/show_user_info_dialog_helpers.dart';
import '../../../../core/widgets/custom_appbar_widget.dart';
import '../../../../core/widgets/error_message_widget.dart';
import '../../../../core/widgets/gradient_background_widget.dart';
import '../../../../core/widgets/loading_message_widget.dart';
import '../../../lead/presentation/pages/lead_sync_page.dart';
import '../../../lead/presentation/pages/leads_page.dart';
import '../bloc/car_bloc.dart';
import '../../../lead/presentation/bloc/lead_bloc.dart';
import '../widgets/car_card.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CarBloc>()..add(const LoadCarsEvent())),
        BlocProvider(create: (_) => di.sl<LeadBloc>()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Carros Disponíveis', 
          backgroundColor: const Color(0xFF191244),
          leading:  IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sincronizar Leads',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadSyncPage()));
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: 'Ver Interessados',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadsPage()));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocListener<LeadBloc, LeadState>(
            listener: (context, state) {
              if (state is LeadSaved) {
                showAppSnackBar(
                  context,
                  message: 'Interesse registrado com sucesso!',
                  backgroundColor: Colors.green[600]!,
                  icon: Icons.check_circle,
                );
              } else if (state is LeadError) {
                showAppSnackBar(
                  context,
                  message: 'Erro: ${state.message}',
                  backgroundColor: Colors.red[600]!,
                  icon: Icons.error,
                );
              }
            },
            child: GradientBackground(
              colors: const [Color(0xFF191244), Colors.white],
              stops: const [0.0, 0.5],
              child: BlocBuilder<CarBloc, CarState>(
                builder: (context, state) {
                  if (state is CarLoading) {
                    return const LoadingMessage(message: 'Carregando carros...');
                  } else if (state is CarLoaded) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isGrid = constraints.maxWidth >= 760; // breakpoint simples
                        final cars = state.cars;
                        final content = isGrid
                            ? GridView.builder(
                                key: const Key('carsGridView'),
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.4,
                                ),
                                itemCount: cars.length,
                                itemBuilder: (context, index) {
                                  final car = cars[index];
                                  return CarCard(
                                    car: car,
                                    onEuQueroPressed: () => showUserInfoDialog(context, car),
                                  );
                                },
                              )
                            : ListView.builder(
                                key: const Key('carsListView'),
                                padding: const EdgeInsets.only(top: 8, bottom: 16),
                                itemCount: cars.length,
                                itemBuilder: (context, index) {
                                  final car = cars[index];
                                  return CarCard(
                                    car: car,
                                    onEuQueroPressed: () => showUserInfoDialog(context, car),
                                  );
                                },
                              );

                        return RefreshIndicator(
                          onRefresh: () async => context.read<CarBloc>().add(const RefreshCarsEvent()),
                          child: content,
                        );
                      },
                    );
                  } else if (state is CarError) {
                    return ErrorMessage(
                      title: 'Erro ao carregar carros',
                      message: state.message,
                      onRetry: () => context.read<CarBloc>().add(const LoadCarsEvent()),
                      color: Colors.blue,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
Resumo (CarPage):
Tela principal listando carros consumidos de API com fallback local. Responsividade essencial
via breakpoint simples para alternar entre ListView e GridView. Integração com LeadBloc para
capturar evento de interesse ("EU QUERO") e fornecer feedback imediato via SnackBar. Também
exibe ações de navegação direta para páginas de sincronização e listagem de leads.
Decisões: Uso de MultiBlocProvider para simplificar escopo e evitar dependências globais na UI;
RefreshIndicator para reforçar controle manual de atualização. Mantido foco em clareza e
redução de sobrecarga visual.
*/