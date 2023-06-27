import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const BarberShopApp());
}

class BarberShopApp extends StatelessWidget {
  const BarberShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barbearia',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const BarberShopPage(),
    );
  }
}

class BarberShopPage extends StatefulWidget {
  const BarberShopPage({Key? key}) : super(key: key);

  @override
  createState() => _BarberShopPageState();
}

class _BarberShopPageState extends State<BarberShopPage> {
  static const int maxCadeirasEspera = 1;

  int numClientesEspera = 0;
  bool barbeiroDormindo = true;
  bool cortandoCabelo = false;
  int clienteAtual = 0;

  final logger = Logger();

  void adicionarCliente() {
    if (barbeiroDormindo) {
      setState(() {
        barbeiroDormindo = false;
        clienteAtual++;
      });
    } else if (numClientesEspera < maxCadeirasEspera) {
      setState(() {
        numClientesEspera++;
        clienteAtual++;
      });
    } else {
      logger.d('Cliente foi embora porque todas as cadeiras estavam ocupadas.');
    }
  }

  void cortarCabeloBarbeiro() {
    if (clienteAtual > 0 && !cortandoCabelo) {
      setState(() {
        cortandoCabelo = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          numClientesEspera = numClientesEspera > 0 ? numClientesEspera - 1 : 0;
          clienteAtual--;
          cortandoCabelo = false;
          barbeiroDormindo = clienteAtual == 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Número de clientes esperando: $numClientesEspera',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            barbeiroDormindo
                ? const Text(
                    'O barbeiro está dormindo.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'O barbeiro está cortando o cabelo do cliente $clienteAtual.',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: adicionarCliente,
              child: const Text('Adicionar Cliente'),
            ),
            const SizedBox(height: 20),
            if (cortandoCabelo) ...[
              const Text(
                'Cortando o cabelo...',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cortarCabeloBarbeiro,
        child: const Icon(Icons.cut),
      ),
    );
  }
}
