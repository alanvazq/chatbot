import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final String repoUrl = "https://github.com/203422";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/up.jpg"),
              )
            ),
            const SizedBox(height: 20),
            
            // Información del estudiante
            const Text(
              'Ingeniería en Software',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            const Text(
              'Programación Móvil',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            
            const Text(
              '9A',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            
            const Text(
              'Alan Manuel Gómez Vázquez',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '203422',
              style: TextStyle(fontSize: 18),
            ),
           const SizedBox(height: 20),

            // Enlace al repositorio
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(repoUrl))) {
                    await launchUrl(Uri.parse(repoUrl));
                  } else {
                    throw 'No se pudo abrir el enlace $repoUrl';
                  }
                },
                child: Text('Ver Repositorio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
