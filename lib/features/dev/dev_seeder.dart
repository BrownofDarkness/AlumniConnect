import 'package:allumni_connect/features/dev/seed_data.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/services/alumni_repository.dart';

class SeedReport {
  const SeedReport({required this.created, required this.skipped});
  final int created;
  final int skipped;

  int get total => created + skipped;
}

class DevSeeder {
  DevSeeder(this._repository);
  final AlumniRepository _repository;

  Future<SeedReport> run() async {
    int created = 0;
    int skipped = 0;
    for (final Alumni a in kSeedAlumni) {
      final existing = await _repository.getAlumni(a.id);
      if (existing != null) {
        skipped++;
        continue;
      }
      await _repository.upsertAlumni(a);
      created++;
    }
    return SeedReport(created: created, skipped: skipped);
  }
}
