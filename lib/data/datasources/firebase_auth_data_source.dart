import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_data_source.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthDataSource firebaseAuthDataSource(Ref ref) {
  return FirebaseAuthDataSource(FirebaseAuth.instance);
}

class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendVerificationCode({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onFailed(e.message ?? '인증에 실패했습니다.');
      },
      codeSent: (String verificationId, int? _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<bool> signInWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.additionalUserInfo?.isNewUser ?? false;
  }

  Future<void> signOut() => _auth.signOut();

  Future<String> getOrCreateUid() async {
    final user = _auth.currentUser ?? await _auth.signInAnonymously().then((c) => c.user);
    return user!.uid;
  }
}
