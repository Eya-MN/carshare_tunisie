import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/bottom_nav.dart';
import '../services/ride_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _departure = TextEditingController();
  final TextEditingController _arrival = TextEditingController();
  int passengers = 1;

  final RideService _rideService = RideService();

  void _goToSearch(BuildContext context) {
    final from = _departure.text.trim();
    final to = _arrival.text.trim();
    final q = <String, String>{
      if (from.isNotEmpty) 'from': from,
      if (to.isNotEmpty) 'to': to,
    };
    final uri = Uri(path: '/search', queryParameters: q.isEmpty ? null : q);
    context.go(uri.toString());
  }

  @override
  void dispose() {
    _departure.dispose();
    _arrival.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('CarShare Tunisie'),
        actions: [
          IconButton(
            onPressed: () => context.go('/publish'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Publier un trajet',
          ),
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (!context.mounted) return;
              context.go('/welcome');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(current: 'home'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Trouver votre trajet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _departure,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.place_outlined),
                      labelText: 'Wilaya de Départ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _arrival,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.place_outlined),
                      labelText: "Wilaya d'Arrivée",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month),
                            labelText: 'Date Départ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month),
                            labelText: 'Date Retour',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.people_outline),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 4,
                          divisions: 3,
                          value: passengers.toDouble(),
                          label: '$passengers',
                          onChanged: (v) => setState(() => passengers = v.round()),
                        ),
                      ),
                      Text('$passengers'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _goToSearch(context),
                    icon: const Icon(Icons.search),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Rechercher'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Trajets disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (user == null)
            const Text('Veuillez vous connecter.', style: TextStyle(color: Colors.black54))
          else
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _rideService.ridesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Text('Aucun trajet pour le moment.');
                }

                return Column(
                  children: docs.map((d) {
                    final data = d.data();
                    final from = (data['from'] ?? '').toString();
                    final to = (data['to'] ?? '').toString();
                    final driverName = (data['driverName'] ?? '').toString();
                    final rating = (data['rating'] ?? '').toString();
                    final price = data['priceTnd'];

                    return InkWell(
                      onTap: () => context.go('/ride/${d.id}'),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.person)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$from → $to', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text('$driverName • $rating ★', style: const TextStyle(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Text('${price ?? ''} TND', style: const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
