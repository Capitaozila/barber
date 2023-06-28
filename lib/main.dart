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

  // Variáveis de controle do estado da barbearia
  int numClientesEspera = 0;
  bool barbeiroDormindo = true;
  bool cortandoCabelo = false;
  int clienteAtual = 0;

  final logger = Logger();

  // Função para adicionar um cliente à barbearia
  void adicionarCliente() {
    if (barbeiroDormindo) {
      // Se o barbeiro estiver dormindo, acorda-o e atende o cliente atual
      setState(() {
        barbeiroDormindo = false;
        clienteAtual++;
      });
    } else if (numClientesEspera < maxCadeirasEspera) {
      // Se o barbeiro estiver ocupado, mas ainda há cadeiras disponíveis, adiciona o cliente à fila de espera
      setState(() {
        numClientesEspera++;
        clienteAtual++;
      });
    } else {
      // Se todas as cadeiras estiverem ocupadas, exibe um diálogo de aviso
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text('Cliente foi embora porque todas as cadeiras estavam ocupadas.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Função para o barbeiro cortar o cabelo de um cliente
  void cortarCabeloBarbeiro() {
    if (clienteAtual > 0 && !cortandoCabelo) {
      // Verifica se há um cliente esperando e se o barbeiro não está cortando o cabelo atualmente
      setState(() {
        cortandoCabelo = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        // Simula o tempo de corte de cabelo (2 segundos)
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
