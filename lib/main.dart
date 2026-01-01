import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/ride_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/group_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const CarShareTunisie());
}

class CarShareTunisie extends StatelessWidget {
  const CarShareTunisie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'CarShare Tunisie',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: authProvider.isAuthenticated 
                ? const DashboardScreen() 
                : const LoginScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/dashboard': (context) => const DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
