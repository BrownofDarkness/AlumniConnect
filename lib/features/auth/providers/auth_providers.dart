import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/services/alumni_repository.dart';
import 'package:allumni_connect/services/auth_service.dart';

final Provider<AuthService> authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final Provider<AlumniRepository> alumniRepositoryProvider =
    Provider<AlumniRepository>((ref) {
  return AlumniRepository();
});

final StreamProvider<User?> authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final Provider<User?> currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

final StreamProvider<Alumni?> currentAlumniProvider =
    StreamProvider<Alumni?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<Alumni?>.value(null);
  return ref.watch(alumniRepositoryProvider).watchAlumni(user.uid);
});

final alumniByUidStreamProvider =
    StreamProvider.family<Alumni?, String>((ref, uid) {
  return ref.watch(alumniRepositoryProvider).watchAlumni(uid);
});
