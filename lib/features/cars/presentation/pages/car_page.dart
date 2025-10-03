import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../lead/domain/entities/lead.dart';
import '../../../lead/presentation/pages/lead_sync_page.dart';
import '../../../lead/presentation/pages/leads_page.dart';
import '../bloc/car_bloc.dart';
import '../../../lead/presentation/bloc/lead_bloc.dart';
import '../widgets/car_card.dart';
import '../widgets/user_info_dialog.dart';

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
        appBar: AppBar(
          title: const Text(
            'Carros Disponíveis',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF191244),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'Sincronizar Leads',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeadSyncPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: 'Ver Interessados',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LeadsPage()),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocListener<LeadBloc, LeadState>(
            listener: (context, state) {
              if (state is LeadSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Interesse registrado com sucesso!'),
                      ],
                    ),
                    backgroundColor: Colors.green[600],
                    duration: const Duration(seconds: 3),
                  ),
                );
              } else if (state is LeadError) {
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
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF191244),
                    Colors.white,
                  ],
                  stops: [0.0, 0.3],
                ),
              ),
              child: BlocBuilder<CarBloc, CarState>(
                builder: (context, state) {
                  if (state is CarLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Carregando carros...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is CarLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CarBloc>().add(const RefreshCarsEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        itemCount: state.cars.length,
                        itemBuilder: (context, index) {
                          final car = state.cars[index];
                          return CarCard(
                            car: car,
                            onEuQueroPressed: () => _showUserInfoDialog(context, car),
                          );
                        },
                      ),
                    );
                  } else if (state is CarError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar carros',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<CarBloc>().add(const LoadCarsEvent());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar Novamente'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> _showUserInfoDialog(BuildContext context, car) async {
    final Lead? lead = await showDialog<Lead>(
      context: context,
      builder: (context) => UserInfoDialog(car: car),
    );

    if (lead != null && mounted) {
      if (context.mounted) {
        context.read<LeadBloc>().add(SaveLeadEvent(lead: lead));
      }
    }
  }
}