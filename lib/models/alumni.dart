/// Modèle représentant un alumni de la communauté.
///
/// Correspond à la structure Firestore définie dans la doc technique.
/// TODO : ajouter fromMap / toMap pour la sérialisation Firestore.
class Alumni {
  final String id;
  final String nom;
  final String prenom;
  final String? photoUrl;
  final String promotion;
  final String filiere;
  final String posteActuel;
  final String entreprise;
  final String bio;

  final String email;
  final String telephone;
  final String linkedin;

  final double latitude;
  final double longitude;
  final String adresse;
  final String ville;
  final String pays;

  final bool visibiliteProfil;
  final bool visibiliteLocalisation;
  final bool profilComplet;

  const Alumni({
    required this.id,
    required this.nom,
    required this.prenom,
    this.photoUrl,
    required this.promotion,
    required this.filiere,
    required this.posteActuel,
    required this.entreprise,
    required this.bio,
    required this.email,
    required this.telephone,
    required this.linkedin,
    required this.latitude,
    required this.longitude,
    required this.adresse,
    required this.ville,
    required this.pays,
    this.visibiliteProfil = true,
    this.visibiliteLocalisation = true,
    this.profilComplet = false,
  });

  Alumni copyWith({
    String? nom,
    String? prenom,
    String? photoUrl,
    String? promotion,
    String? filiere,
    String? posteActuel,
    String? entreprise,
    String? bio,
    String? email,
    String? telephone,
    String? linkedin,
    double? latitude,
    double? longitude,
    String? adresse,
    String? ville,
    String? pays,
    bool? visibiliteProfil,
    bool? visibiliteLocalisation,
    bool? profilComplet,
  }) {
    return Alumni(
      id: id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      photoUrl: photoUrl ?? this.photoUrl,
      promotion: promotion ?? this.promotion,
      filiere: filiere ?? this.filiere,
      posteActuel: posteActuel ?? this.posteActuel,
      entreprise: entreprise ?? this.entreprise,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      linkedin: linkedin ?? this.linkedin,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      visibiliteProfil: visibiliteProfil ?? this.visibiliteProfil,
      visibiliteLocalisation: visibiliteLocalisation ?? this.visibiliteLocalisation,
      profilComplet: profilComplet ?? this.profilComplet,
    );
  }
}
