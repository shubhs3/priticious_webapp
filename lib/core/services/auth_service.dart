import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../utils/firestore_helpers.dart';
import 'firebase_bootstrap.dart';
import 'firebase_providers.dart';
import 'seed_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  if (!FirebaseBootstrap.isInitialized) {
    return Stream.value(null);
  }
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserProvider = StreamProvider<UserModel?>((ref) async* {
  if (!FirebaseBootstrap.isInitialized) {
    yield null;
    return;
  }
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) {
    yield null;
    return;
  }

  final firestore = ref.watch(firestoreProvider);
  await for (final snapshot in firestore.collection('users').doc(user.uid).snapshots()) {
    if (!snapshot.exists) {
      yield null;
      continue;
    }
    yield UserModel.fromJson(docDataWithId(snapshot));
  }
});

final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.maybeWhen(
    data: (model) => model?.role == UserRole.admin,
    orElse: () => false,
  );
});

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

class AdminAuthService {
  AdminAuthService(this._auth, this._seedService);

  final FirebaseAuth _auth;
  final SeedService _seedService;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await _seedService.ensureAdminUser();
  }

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _seedService.ensureAdminUser();
  }

  Future<void> signOut() => _auth.signOut();
}

final adminAuthServiceProvider = Provider<AdminAuthService>((ref) {
  return AdminAuthService(
    ref.watch(firebaseAuthProvider),
    ref.watch(seedServiceProvider),
  );
});
