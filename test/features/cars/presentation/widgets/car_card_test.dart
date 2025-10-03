import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:teste_ws_work_flutter/features/cars/domain/entities/car.dart';
import 'package:teste_ws_work_flutter/features/cars/presentation/widgets/car_card.dart';

void main() {
  group('CarCard Widget', () {
    const tCar = Car(
      id: 1,
      timestampCadastro: 1696539488,
      modeloId: 12,
      ano: 2015,
      combustivel: 'FLEX',
      numPortas: 4,
      cor: 'BEGE',
      nomeModelo: 'ONIX PLUS',
      valor: 50000.0,
    );

    testWidgets('should display car information correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(
              car: tCar,
              onEuQueroPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('ONIX PLUS'), findsOneWidget);
      expect(find.text('R\$ 50.000'), findsOneWidget);
      expect(find.text('2015'), findsOneWidget);
      expect(find.text('flex'), findsOneWidget);
      expect(find.text('4 portas'), findsOneWidget);
      expect(find.text('bege'), findsOneWidget);
      expect(find.text('EU QUERO'), findsOneWidget);
    });

    testWidgets('should call onEuQueroPressed when button is pressed', (WidgetTester tester) async {
      // Arrange
      bool buttonPressed = false;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(
              car: tCar,
              onEuQueroPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('EU QUERO'));
      await tester.pump();

      // Assert
      expect(buttonPressed, isTrue);
    });

    testWidgets('should display all required icons', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarCard(
              car: tCar,
              onEuQueroPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.local_gas_station), findsOneWidget);
      expect(find.byIcon(Icons.door_front_door), findsOneWidget);
      expect(find.byIcon(Icons.palette), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}