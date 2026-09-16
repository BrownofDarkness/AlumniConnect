class IdentityData {
  final String prenom;
  final String nom;
  final String promotion;
  final String filiere;
  final String posteActuel;
  final String entreprise;
  final String bio;
  final String? photoUrl;

  const IdentityData({
    required this.prenom,
    required this.nom,
    required this.promotion,
    this.filiere = '',
    this.posteActuel = '',
    this.entreprise = '',
    this.bio = '',
    this.photoUrl,
  });
}

class ContactData {
  final String email;
  final String telephone;
  final String linkedin;

  const ContactData({
    this.email = '',
    this.telephone = '',
    this.linkedin = '',
  });
}

class LocationData {
  final String adresse;
  final String ville;
  final String pays;

  const LocationData({
    required this.adresse,
    required this.ville,
    required this.pays,
  });
}

class SecurityData {
  final String newPassword;

  const SecurityData({required this.newPassword});
}
