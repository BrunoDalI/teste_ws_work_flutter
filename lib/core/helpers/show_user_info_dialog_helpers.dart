import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/cars/presentation/widgets/user_info_dialog.dart';
import '../../features/lead/domain/entities/lead.dart';
import '../../features/lead/presentation/bloc/lead_bloc.dart';

Future<void> showUserInfoDialog(BuildContext context, car) async {
    final Lead? lead = await showDialog<Lead>(
      context: context,
      builder: (context) => UserInfoDialog(car: car),
    );

    if (lead != null) {
      if (context.mounted) {
        context.read<LeadBloc>().add(SaveLeadEvent(lead: lead));
      }
    }
  }