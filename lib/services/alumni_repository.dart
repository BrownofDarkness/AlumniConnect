import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:allumni_connect/models/alumni.dart';

const String firestoreDatabaseId = 'alumni-connect';

class AlumniRepository {
  AlumniRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ??
            FirebaseFirestore.instanceFor(
              app: Firebase.app(),
              databaseId: firestoreDatabaseId,
            );

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('alumni');

  Future<Alumni?> getAlumni(String id) async {
    final snap = await _col.doc(id).get();
    if (!snap.exists) return null;
    return Alumni.fromMap(snap.id, snap.data()!);
  }

  Stream<Alumni?> watchAlumni(String id) {
    return _col.doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      return Alumni.fromMap(snap.id, snap.data()!);
    });
  }

  Stream<List<Alumni>> watchAllAlumni() {
    return _col.snapshots().map((query) {
      return query.docs
          .map((doc) => Alumni.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> upsertAlumni(Alumni alumni) async {
    final data = alumni.toMap()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    if (alumni.createdAt == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await _col.doc(alumni.id).set(data, SetOptions(merge: true));
  }

  Future<void> updateFields(String id, Map<String, dynamic> fields) async {
    await _col.doc(id).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAlumni(String id) async {
    await _col.doc(id).delete();
  }
}
