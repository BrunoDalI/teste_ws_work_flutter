import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lead.dart';
import '../repositories/lead_repository.dart';

/// Use case for sending multiple leads to remote API
class SendLeads implements UseCase<void, SendLeadsParams> {
  final LeadRepository repository;

  SendLeads(this.repository);

  @override
  Future<Either<Failure, void>> call(SendLeadsParams params) async {
    return await repository.sendLeads(params.leads);
  }
}

/*
Resumo (SendLeads):
Envia lote de leads em uma única chamada do repositório permitindo otimização
e redução de overhead de rede. Parâmetro explícito permite adicionar flags
posteriores (ex: prioridade) sem quebrar assinaturas existentes.
*/

/// Parameters for SendLeads use case
class SendLeadsParams {
  final List<Lead> leads;

  const SendLeadsParams({required this.leads});
}