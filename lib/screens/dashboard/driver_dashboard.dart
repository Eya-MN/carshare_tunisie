import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ride_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../config/theme.dart';
import '../../models/user.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id;
    
    if (userId != null) {
      await context.read<RideProvider>().fetchMyRides(userId);
      await context.read<WalletProvider>().fetchBalance(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarShare Tunisie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Navigate to create ride
              },
              icon: const Icon(Icons.add),
              label: const Text('Publier'),
            )
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                ),
                accountName: Text(user?.fullName ?? ''),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: user?.profileImageUrl != null
                      ? null
                      : Text(
                          user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mon profil'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to profile
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text('Mes véhicules'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to vehicles
                },
              ),
              ListTile(
                leading: const Icon(Icons.request_page),
                title: const Text('Demandes de trajets'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to ride requests
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Demandes acceptées'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to accepted requests
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Groupes'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to groups
                },
              ),
              ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text('Social & Innovation'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to social
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Sécurité'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to security
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to settings
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Passer en mode Passager'),
                onTap: () {
                  authProvider.switchRole(UserRole.passenger);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorRed),
                title: const Text(
                  'Déconnexion',
                  style: TextStyle(color: AppTheme.errorRed),
                ),
                onTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildRidesTab();
      case 2:
        return _buildWalletTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildStatsRow(),
            const SizedBox(height: 24),
            Text(
              'Actions rapides',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildQuickActions(),
            const SizedBox(height: 24),
            Text(
              'Prochains trajets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildUpcomingRides(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${user?.fullName.split(' ')[0] ?? "Conducteur"}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Prêt pour un nouveau trajet ?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Consumer2<RideProvider, WalletProvider>(
      builder: (context, rideProvider, walletProvider, _) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.directions_car,
                label: 'Trajets',
                value: '${rideProvider.myRides.length}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                label: 'Passagers',
                value: '24',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.account_balance_wallet,
                label: 'Solde',
                value: '${walletProvider.balance.toStringAsFixed(0)} TND',
                color: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.add_circle_outline,
            label: 'Publier',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.directions_car_outlined,
            label: 'Véhicules',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.request_page_outlined,
            label: 'Demandes',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryBlue),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingRides() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        if (rideProvider.myRides.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun trajet publié',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: rideProvider.myRides.take(3).map((ride) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ride.fromCity} → ${ride.toCity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${ride.departureDate.day}/${ride.departureDate.month}/${ride.departureDate.year}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        ride.departureTime,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRidesTab() {
    return const Center(child: Text('Mes trajets'));
  }

  Widget _buildWalletTab() {
    return const Center(child: Text('Portefeuille'));
  }

  Widget _buildProfileTab() {
    return const Center(child: Text('Profil'));
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryBlue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Trajets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Portefeuille',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
