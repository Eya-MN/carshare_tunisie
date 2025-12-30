import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/ride_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _isRegister = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _continue(BuildContext context) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final auth = AuthService();
      final rideService = RideService();

      if (_isRegister) {
        if (_password.text != _confirmPassword.text) {
          throw Exception('Les mots de passe ne correspondent pas.');
        }
        if (_password.text.length < 6) {
          throw Exception('Le mot de passe doit contenir au moins 6 caractères.');
        }
      }

      final email = _email.text.trim();
      final password = _password.text;

      final cred = _isRegister
          ? await auth.signUpWithEmail(email: email, password: password)
          : await auth.signInWithEmail(email: email, password: password);

      await rideService.ensureUserDoc(user: cred.user!);
      await rideService.seedSampleRideIfEmpty(user: cred.user!);

      if (!context.mounted) return;
      context.go('/verification');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _friendlyAuthError(e);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_car, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bienvenue sur CarShare Tunisie',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connectez-vous ou créez un compte pour commencer votre voyage.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(value: false, label: Text('Connexion')),
                          ButtonSegment<bool>(value: true, label: Text('Inscription')),
                        ],
                        selected: <bool>{_isRegister},
                        onSelectionChanged: _loading
                            ? null
                            : (v) {
                                setState(() {
                                  _isRegister = v.first;
                                  _error = null;
                                });
                              },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Adresse email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        obscureText: true,
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (_isRegister) ...[
                        const SizedBox(height: 12),
                        TextField(
                          obscureText: true,
                          controller: _confirmPassword,
                          decoration: const InputDecoration(
                            labelText: 'Confirmer le mot de passe',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (_error != null) ...[
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _loading ? null : () => _continue(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              _loading
                                  ? 'Chargement...'
                                  : (_isRegister ? 'Créer un compte' : 'Se connecter'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé. Essayez Connexion.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible (minimum 6 caractères).';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email. Essayez Inscription.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'operation-not-allowed':
        return "Méthode Email/Mot de passe désactivée dans Firebase. Active-la dans Firebase Console > Authentication > Sign-in method.";
      case 'network-request-failed':
        return 'Problème réseau. Vérifie ta connexion Internet.';
      default:
        return e.message ?? 'Erreur Auth: ${e.code}';
    }
  }
}
