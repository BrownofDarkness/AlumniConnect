import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/utils/custom_exceptions.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/onboarding/models/onboarding_data.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/confirmation_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/contact_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/identity_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/location_choice_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/location_manual_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/security_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/welcome_step.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/services/location_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _welcome = 0;
  static const int _identity = 1;
  static const int _contact = 2;
  static const int _locationChoice = 3;
  static const int _locationManual = 4;
  static const int _security = 5;
  static const int _confirmation = 6;

  final PageController _controller = PageController();
  int _current = _welcome;

  bool _fromGps = false;
  LocationResult? _gpsResult;

  IdentityData? _identityData;
  ContactData? _contactData;
  LocationData? _locationData;
  SecurityData? _securityData;

  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    await _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleHardwareBack() async {
    if (_current == _welcome || _current == _confirmation) return;
    await _goTo(_current - 1);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Flexible(
                    child: Text(
                      'Nous prenons votre localisation, veuillez patienter...',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    AppSnackBar.error(context, message);
  }

  Future<void> _useCurrentPosition() async {
    _showLoadingDialog(context);

    try {
      final result = await LocationService.getCurrentLocation();
      if (!mounted) return;

      setState(() {
        _fromGps = true;
        _gpsResult = result;
      });

      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      await _goTo(_locationManual);
    } on LocationPermissionException catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showError(e.message);
    } on LocationServiceException catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showError(e.message);
    } catch (_) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showError('Une erreur est survenue.');
    }
  }

  Future<void> _finish() async {
    if (_submitting) return;
    if (_identityData == null || _locationData == null) {
      _showError('Certaines informations sont manquantes.');
      return;
    }

    setState(() => _submitting = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw UnknownAuthException();

      double latitude;
      double longitude;

      if (_fromGps && _gpsResult != null) {
        latitude = _gpsResult!.latitude;
        longitude = _gpsResult!.longitude;
      } else {
        final geo = await LocationService.getLocationFromAddress(
          address: _locationData!.adresse,
          city: _locationData!.ville,
          country: _locationData!.pays,
        );
        latitude = geo.latitude;
        longitude = geo.longitude;
      }

      if (_securityData != null && _securityData!.newPassword.isNotEmpty) {
        await ref.read(authServiceProvider).updatePassword(_securityData!.newPassword);
      }

      final alumni = Alumni(
        id: user.uid,
        nom: _identityData!.nom,
        prenom: _identityData!.prenom,
        photoUrl: _identityData!.photoUrl,
        promotion: _identityData!.promotion,
        filiere: _identityData!.filiere,
        posteActuel: _identityData!.posteActuel,
        entreprise: _identityData!.entreprise,
        bio: _identityData!.bio,
        email: _contactData?.email.isNotEmpty == true
            ? _contactData!.email
            : (user.email ?? ''),
        telephone: _contactData?.telephone ?? '',
        linkedin: _contactData?.linkedin ?? '',
        latitude: latitude,
        longitude: longitude,
        adresse: _locationData!.adresse,
        ville: _locationData!.ville,
        pays: _locationData!.pays,
        profilComplet: true,
      );

      await ref.read(alumniRepositoryProvider).upsertAlumni(alumni);
      // Router redirect prend le relai : profilComplet=true → /directory
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _showError('Impossible de sauvegarder ton profil. Réessaie.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalEmail = ref.watch(currentUserProvider)?.email;

    return PopScope(
      canPop: _current == _welcome,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handleHardwareBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WelcomeStep(onContinue: () => _goTo(_identity)),
              IdentityStep(
                onContinue: (data) {
                  setState(() => _identityData = data);
                  _goTo(_contact);
                },
                onBack: () => _goTo(_welcome),
              ),
              ContactStep(
                personalEmail: personalEmail,
                onContinue: (data) {
                  setState(() => _contactData = data);
                  _goTo(_locationChoice);
                },
                onBack: () => _goTo(_identity),
              ),
              LocationChoiceStep(
                onChooseGps: _useCurrentPosition,
                onChooseManual: () {
                  setState(() {
                    _fromGps = false;
                    _gpsResult = null;
                  });
                  _goTo(_locationManual);
                },
                onBack: () => _goTo(_contact),
              ),
              LocationManualStep(
                fromGps: _fromGps,
                locationResult: _gpsResult,
                onContinue: (data) {
                  setState(() => _locationData = data);
                  _goTo(_security);
                },
                onBack: () => _goTo(_locationChoice),
              ),
              SecurityStep(
                onContinue: (data) {
                  setState(() => _securityData = data);
                  _goTo(_confirmation);
                },
                onSkip: () {
                  setState(() => _securityData = null);
                  _goTo(_confirmation);
                },
                onBack: () => _goTo(_locationManual),
              ),
              ConfirmationStep(
                onFinish: _finish,
                submitting: _submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
