# CarShare Tunisie 🚗

Une application mobile de covoiturage moderne pour la Tunisie, développée avec Flutter et Firebase.

## 📋 Description

CarShare Tunisie est une plateforme de covoiturage qui connecte les conducteurs et les passagers tunisiens pour des trajets sûrs, économiques et écologiques. L'application offre une expérience utilisateur complète avec des fonctionnalités avancées de sécurité et de paiement.

## ✨ Fonctionnalités Principales

### 🎯 Fonctionnalités de Base
- **Inscription et Connexion Sécurisées** avec validation par email
- **Rôles Utilisateurs** : Conducteur et Passager
- **Recherche de Trajets** avec filtres (départ, destination, date)
- **Publication de Trajets** avec gestion des places disponibles
- **Réservation de Trajets** avec confirmation instantanée
- **Système de Paiement** : Espèces, Carte bancaire, Orange Money, Ooredoo Money

### 🔐 Fonctionnalités de Sécurité
- **Vérification d'Identité** avec CIN (Carte d'Identité Nationale)
- **Validation de Numéro de Téléphone** (format tunisien)
- **Journalisation des Événements de Sécurité**
- **Détection d'Activités Suspectes**
- **Verrouillage Temporaire de Compte**
- **Nettoyage des Entrées Utilisateur** (XSS prevention)

### 👤 Gestion de Profil
- **Photo de Profil** avec upload sur Firebase Storage
- **Informations Personnelles** : nom, téléphone, rôle
- **Historique des Trajets**
- **Statistiques Personnelles**

### 🌐 Navigation et Interface
- **Tableau de Bord** interactif avec statistiques
- **Écran des Demandes** avec gestion acceptation/refus
- **Écran des Trajets** (publiés et réservés)
- **Suggestions IA** pour les trajets optimisés
- **Social & Innovation** avec empreinte carbone
- **Paramètres** avec partage de position, langue
- **Groupes de Covoiturage** thématiques et régionaux

### 💡 Fonctionnalités Innovantes
- **Suggestions IA** pour les trajets et éco-conduite
- **Calcul d'Empreinte Carbone** personnelle
- **Graphiques et Statistiques** détaillées
- **Groupes Communautaires** (professionnel, étudiant, événementiel)
- **Mode Femmes Uniquement** pour certains trajets

## 🛠 Stack Technique

### Frontend
- **Flutter 3.38.5** - Framework de développement mobile
- **Dart 3.10.4** - Langage de programmation
- **Go Router** - Navigation et routing
- **Material Design 3** - Interface utilisateur moderne

### Backend
- **Firebase Authentication** - Authentification des utilisateurs
- **Cloud Firestore** - Base de données NoSQL en temps réel
- **Firebase Storage** - Stockage des fichiers (photos, CIN)
- **Firebase Hosting** - Hébergement web (optionnel)

### Architecture
- **Architecture MVC** (Model-View-Controller)
- **Services Layer** pour la logique métier
- **Widgets réutilisables** pour l'interface
- **Streams Firestore** pour les mises à jour en temps réel

## 📱 Écrans de l'Application

### 🏠 Écrans Principaux
1. **WelcomeScreen** - Inscription/Connexion
2. **DashboardScreen** - Tableau de bord personnel
3. **HomeScreen** - Recherche de trajets
4. **RequestsScreen** - Gestion des demandes
5. **TripsScreen** - Trajets publiés/réservés
6. **ProfileScreen** - Profil utilisateur

### 🆕 Écrans Avancés
7. **SuggestionsScreen** - Recommandations IA
8. **SocialInnovationScreen** - Impact écologique
9. **SettingsScreen** - Paramètres et préférences
10. **GroupsScreen** - Groupes de covoiturage

### 🎯 Écrans Transactionnels
11. **PublishRideScreen** - Publication de trajet
12. **RideDetailsScreen** - Détails d'un trajet
13. **PaymentScreen** - Paiement et réservation
14. **BookingDetailsScreen** - Détails de réservation
15. **VerificationScreen** - Vérification d'identité

## 🗂 Structure des Collections Firestore

### users
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "phone": "string",
  "role": "driver|passenger",
  "cinNumber": "string",
  "cinFileUrl": "string",
  "photoUrl": "string",
  "isVerified": "boolean",
  "createdAt": "timestamp",
  "lockedUntil": "timestamp|null"
}
```

### rides
```json
{
  "driverId": "string",
  "driverName": "string",
  "from": "string",
  "to": "string",
  "departureTime": "timestamp",
  "priceTnd": "number",
  "seatsAvailable": "number",
  "womenOnly": "boolean",
  "createdAt": "timestamp",
  "status": "active|completed|cancelled"
}
```

### bookings
```json
{
  "userId": "string",
  "rideId": "string",
  "driverId": "string",
  "paymentMethod": "cash|card|orange_money|ooredoo_money",
  "status": "pending|confirmed|cancelled|completed",
  "createdAt": "timestamp"
}
```

### ride_requests
```json
{
  "userId": "string",
  "rideId": "string",
  "driverId": "string",
  "status": "pending|accepted|rejected",
  "createdAt": "timestamp"
}
```

## 🚀 Installation et Configuration

### Prérequis
- **Flutter SDK 3.38.5+**
- **Dart SDK 3.10.4+**
- **Android Studio** ou **VS Code**
- **Android SDK** (pour développement Android)
- **Xcode** (pour développement iOS)
- **Compte Firebase**

### Étapes d'Installation

1. **Cloner le dépôt**
```bash
git clone https://github.com/Eya-MN/carshare_tunisie.git
cd carshare_tunisie
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer Firebase**
   - Créer un projet sur [Firebase Console](https://console.firebase.google.com/)
   - Activer Authentication, Firestore, et Storage
   - Télécharger `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
   - Placer les fichiers dans les dossiers appropriés

4. **Activer le mode développeur** (Windows)
```bash
start ms-settings:developers
```

5. **Lancer l'application**
```bash
# Pour Chrome (Web)
flutter run -d chrome

# Pour Android
flutter run -d android

# Pour iOS
flutter run -d ios
```

## 🔧 Configuration des Variables d'Environnement

Créer un fichier `lib/config/firebase_config.dart` :

```dart
class FirebaseConfig {
  static const String projectId = 'your-project-id';
  static const String apiKey = 'your-api-key';
  static const String appId = 'your-app-id';
  static const String messagingSenderId = 'your-sender-id';
}
```

## 📊 Tests et Débogage

### Tests Unitaires
```bash
flutter test
```

### Analyse du Code
```bash
flutter analyze
```

### Tests d'Intégration
```bash
flutter drive --target=test_driver/app_test.dart
```

## 🎨 Personnalisation

### Couleurs de l'Application
- **Bleu Primaire** : `#2563EB`
- **Vert Succès** : `#10B981`
- **Violet Innovation** : `#8B5CF6`
- **Gris Texte** : `#1F2937`
- **Gris Secondaire** : `#6B7280`

### Icônes et Assets
Les icônes sont générées avec `flutter_launcher_icons` et les images sont optimisées pour différentes densités d'écran.

## 🚀 Déploiement

### Web (Firebase Hosting)
```bash
flutter build web
firebase deploy --only hosting
```

### Android (Google Play Store)
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS (App Store)
```bash
flutter build ios --release
```

## 🤝 Contributeurs

- **Eya MN** - Développeur principal et architecte de l'application

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- **Firebase** pour l'infrastructure backend
- **Flutter** pour le framework de développement
- **Material Design** pour les guidelines UI/UX
- La communauté tunisienne pour son soutien et ses retours

## 📞 Contact

- **Email** : eya.mn@example.com
- **GitHub** : [@Eya-MN](https://github.com/Eya-MN)
- **LinkedIn** : [Eya MN](https://linkedin.com/in/eya-mn)

## 🗺 Roadmap Futur

### Version 2.0
- [ ] Notifications push en temps réel
- [ ] Chat intégré entre conducteurs et passagers
- [ ] Système de notation et avis
- [ ] Intégration paiement en ligne sécurisée
- [ ] Mode hors-ligne partiel

### Version 3.0
- [ ] IA pour optimisation des trajets
- [ ] Gamification et programme de fidélité
- [ ] Intégration transport public
- [ ] Expansion internationale
- [ ] API pour partenaires tiers

---

**Développé avec ❤️ en Tunisie**
