import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: const Text('Groupes de covoiturage'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNav(current: 'groups'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            const Text(
              'Rejoignez une communauté et partagez vos trajets',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            
            // Professional Carpooling
            _buildGroupCard(
              icon: Icons.business_center,
              iconColor: const Color(0xFF2563EB),
              title: 'Covoiturage professionnel',
              description: 'Pour vos trajets quotidiens travail-maison',
              members: '1245 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFF2563EB),
              onTap: () => _joinGroup('professionnel'),
            ),
            
            const SizedBox(height: 16),
            
            // Student Carpooling
            _buildGroupCard(
              icon: Icons.school,
              iconColor: const Color(0xFF8B5CF6),
              title: 'Covoiturage étudiant',
              description: 'Déplacements entre campus et résidences',
              members: '3892 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFF8B5CF6),
              onTap: () => _joinGroup('étudiant'),
            ),
            
            const SizedBox(height: 16),
            
            // Event Carpooling
            _buildGroupCard(
              icon: Icons.event,
              iconColor: const Color(0xFFF97316),
              title: 'Covoiturage événementiel',
              description: 'Pour concerts, festivals et événements',
              members: '856 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFFF97316),
              onTap: () => _joinGroup('événementiel'),
            ),
            
            const SizedBox(height: 32),
            
            // Regional Groups Section
            const Text(
              'Groupes régionaux',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            
            // North Tunisia
            _buildGroupCard(
              icon: Icons.location_on,
              iconColor: const Color(0xFF10B981),
              title: 'Covoiturage Tunisie-Nord',
              description: 'Trajets Tunis, Bizerte, Nabeul et régions',
              members: '2134 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFF10B981),
              onTap: () => _joinGroup('nord'),
            ),
            
            const SizedBox(height: 16),
            
            // Center Tunisia
            _buildGroupCard(
              icon: Icons.location_on,
              iconColor: const Color(0xFF06B6D4),
              title: 'Covoiturage Tunisie-Centre',
              description: 'Trajets Sousse, Monastir, Mahdia et régions',
              members: '1876 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFF06B6D4),
              onTap: () => _joinGroup('centre'),
            ),
            
            const SizedBox(height: 16),
            
            // South Tunisia
            _buildGroupCard(
              icon: Icons.location_on,
              iconColor: const Color(0xFFEF4444),
              title: 'Covoiturage Tunisie-Sud',
              description: 'Trajets Sfax, Gabès, Djerba et régions',
              members: '1423 membres',
              buttonText: 'Rejoindre',
              buttonColor: const Color(0xFFEF4444),
              onTap: () => _joinGroup('sud'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String members,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                members,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _joinGroup(String groupType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rejoindre le groupe $groupType'),
        content: const Text('Vous êtes sur le point de rejoindre ce groupe. Voulez-vous continuer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vous avez rejoint le groupe $groupType!'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
