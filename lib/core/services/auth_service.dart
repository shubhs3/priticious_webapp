import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      yield UserModel(
        id: user.uid,
        displayName: (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName!
            : 'Customer',
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        role: UserRole.customer,
        isActive: true,
      );
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

class CustomerAuthService {
  CustomerAuthService(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'displayName': displayName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': 'customer',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'displayName': user.displayName ?? '',
            'email': user.email ?? '',
            'phoneNumber': user.phoneNumber ?? '',
            'role': 'customer',
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        } else {
          await _firestore.collection('users').doc(user.uid).update({
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        }
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'displayName': displayName,
        'phoneNumber': phoneNumber,
      });
    }
  }
}

final customerAuthServiceProvider = Provider<CustomerAuthService>((ref) {
  return CustomerAuthService(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreProvider),
  );
});
