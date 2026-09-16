# AlumniConnect

> L'annuaire vivant de la communauté des anciens — retrouve tes camarades de promotion, où qu'ils soient, dans une app mobile invite-only.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-FFCA28?logo=firebase)
![Riverpod](https://img.shields.io/badge/Riverpod-3.4-40C4FF)
![Design](https://img.shields.io/badge/Design-Light%20%2B%20Dark-1A1F2B)

---

## Contexte

Projet livré par le **Groupe 11** dans le cadre du **FlutterFire Summer Camp**. Le sujet : construire un annuaire mobile pour une communauté d'anciens apprenants, avec une inscription contrôlée (invite-only), un système de recherche et de filtres, et une visualisation cartographique de la répartition géographique des membres.

Le fil rouge du projet : partir d'une maquette haute-fidélité complète (parcours utilisateur des 21 écrans, mode clair **et** sombre), la reproduire fidèlement en Flutter, et brancher tout ça sur Firebase pour un fonctionnement en temps réel.

## Fonctionnalités

- ✅ **Authentification** : email/password, mot de passe oublié (envoi d'un lien de récupération), changement de mot de passe avec réauthentification
- ✅ **Onboarding en 7 étapes** : identité, coordonnées, localisation (GPS ou saisie manuelle avec reverse-geocoding), sécurité, confirmation
- ✅ **Annuaire** : recherche texte, filtres cumulables (pays, ville, promotion, filière, proximité géographique)
- ✅ **Fiche alumni** : parcours, biographie, coordonnées, carte de localisation, raccourcis email/appel/LinkedIn
- ✅ **Carte interactive** : pins des alumni dans un rayon configurable (5 à 200 km), fiche flottante au tap
- ✅ **Itinéraire** : trace la distance à vol d'oiseau entre l'utilisateur et un alumni sélectionné
- ✅ **Profil personnel** : édition identité/parcours pro, bio en édition rapide via bottom sheet
- ✅ **Réglages** : toggle thème (clair/sombre/auto) persisté, changement de mot de passe, déconnexion
- ✅ **Bouton seed dev** : peupler l'annuaire en 1 clic avec 19 profils de test (idempotent, visible uniquement en `kDebugMode`)

## Stack technique

| Domaine | Techno | Version |
|---|---|---|
| Framework | Flutter | 3.x |
| Langage | Dart | ≥ 3.12 |
| State management | flutter_riverpod | 3.4 |
| Routing | go_router | 18.0 |
| Backend | firebase_core / firebase_auth / cloud_firestore | 4.14 / 6.7 / 6.10 |
| Cartes | flutter_map + latlong2 | 8.3 / 0.10 |
| Géoloc | geolocator + geocoding | 14.0 / 5.0 |
| Persistence locale | shared_preferences | 2.5 |
| Icons | material_symbols_icons, lucide_icons_flutter | — |
| Snackbars | top_snackbar_flutter | 3.4 |
| Typo | google_fonts (Inter) | 8.2 |

## Architecture

Structure **feature-first** : chaque domaine fonctionnel est autonome (`features/<domaine>/{screens,widgets,providers,models,data}`), les briques transverses vivent dans `core/`, les points de contact avec Firebase dans `services/`, les modèles de domaine dans `models/`.

```
lib/
├── core/
│   ├── constants/       # AppColors, AppSpacing
│   ├── theme/           # AppTheme (light + dark)
│   ├── providers/       # ThemeMode
│   ├── utils/           # validators, geo, exceptions
│   └── widgets/         # AppButton, AppTextField, AppSnackBar, MainScaffold
├── features/
│   ├── auth/            # Login, ForgotPassword, Splash
│   ├── onboarding/      # 7 steps + shell
│   ├── directory/       # Annuaire + filtres
│   ├── detail/          # Fiche alumni
│   ├── map/             # Carte + markers + card flottante
│   ├── itinerary/       # Vue itinéraire
│   ├── profile/         # Mon profil + édition + bio sheet
│   ├── settings/        # Réglages + changement mot de passe
│   ├── dev/             # Seeder + données de test
│   └── admin/           # Ajouter alumni (à venir)
├── models/              # Alumni
├── routing/             # app_router + routes
├── services/            # AuthService, AlumniRepository, LocationService
└── main.dart
```

**Pattern de données** : un `StreamProvider<List<Alumni>>` branché sur Firestore + une façade synchrone `Provider<List<Alumni>>` pour ne pas contaminer tous les downstream avec des `AsyncValue`. Les écrans gèrent le loading/error au niveau haut via le stream.

## Design system

Palette validée avec la maquette :

| Token | Light | Dark |
|---|---|---|
| Primary | `#2B4A8B` (navy) | `#F5A623` (amber) |
| Surface | `#FFFFFF` | `#142E52` |
| Scaffold | `#F5F7FA` (cream) | `#0A2540` (navy) |
| On-surface | `#1A1F2B` (ink) | `#F5F7FA` (cream) |
| Muted | `#5A6472` | `#8FA0B8` |
| Amber accent | `#F5A623` | `#F5A623` |

Typographie **Inter** (400/500/600/700/800), échelle de tailles définie dans `AppTextStyles`.

Chaque widget utilise `Theme.of(context).colorScheme.*` — aucune couleur figée dans les composants, ce qui garantit un mode sombre cohérent partout.

## Getting started

### Prérequis
- Flutter SDK ≥ 3.12
- Android Studio / Xcode (selon la cible)
- Un projet Firebase configuré (voir section suivante)

### Installation

```bash
git clone <repo-url>
cd AlumniConnect
flutter pub get
flutter run
```

## Configuration Firebase

L'app dépend de trois choses côté Firebase :

1. **Firebase Auth** avec le provider Email/Password activé
2. **Firestore** avec une base nommée **`alumni-connect`** (⚠️ pas la base `(default)`)
3. Les **rules** publiées (fournies par l'équipe)

Le fichier `firebase_options.dart` doit être régénéré pour ton projet avec `flutterfire configure`.

## Peupler l'annuaire (mode dev)

Pour éviter de créer 19 profils à la main, un utilitaire de seed est intégré directement dans l'app :

1. Lance l'app en debug et connecte-toi avec un compte existant
2. Va dans **Réglages** → section **Debug** → **« Peupler l'annuaire de test »**
3. Confirme le dialog

Le seed :
- Est **idempotent** : les profils déjà présents sont ignorés
- Crée 19 alumni répartis sur 6 pays (Cameroun, Sénégal, Côte d'Ivoire, Togo, France) avec de vraies coordonnées GPS
- Utilise le préfixe `alum_XXX` pour distinguer les profils seed des vrais utilisateurs

⚠️ La section Debug n'apparaît qu'en `kDebugMode` — elle est totalement invisible en build release.

## Roadmap

Ce qui reste sur la table :

- 📸 Upload de photo de profil (Firebase Storage)
- ✉️ Système d'invitation réel (Cloud Functions + email transactionnel)
- 🔔 Notifications push
- 👁️ Persistance des toggles de visibilité (profil, position) dans Firestore
- 🧹 Suppression complète du `MockAlumniRepository` une fois l'annuaire 100% live validé
- 🌐 Traduction multi-langue
