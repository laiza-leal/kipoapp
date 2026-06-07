import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/detail';

  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Center(
        child: Text(message ?? 'Sem mensagem'),
      ),
    );
  }
}
