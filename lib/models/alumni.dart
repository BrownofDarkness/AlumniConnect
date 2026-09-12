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
}
