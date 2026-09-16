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

  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory Alumni.newProfile({
    required String id,
    required String email,
  }) {
    return Alumni(
      id: id,
      nom: '',
      prenom: '',
      promotion: '',
      filiere: '',
      posteActuel: '',
      entreprise: '',
      bio: '',
      email: email,
      telephone: '',
      linkedin: '',
      latitude: 0,
      longitude: 0,
      adresse: '',
      ville: '',
      pays: '',
      profilComplet: false,
    );
  }

  factory Alumni.fromMap(String id, Map<String, dynamic> map) {
    return Alumni(
      id: id,
      nom: (map['nom'] as String?) ?? '',
      prenom: (map['prenom'] as String?) ?? '',
      photoUrl: map['photoUrl'] as String?,
      promotion: (map['promotion'] as String?) ?? '',
      filiere: (map['filiere'] as String?) ?? '',
      posteActuel: (map['posteActuel'] as String?) ?? '',
      entreprise: (map['entreprise'] as String?) ?? '',
      bio: (map['bio'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      telephone: (map['telephone'] as String?) ?? '',
      linkedin: (map['linkedin'] as String?) ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      adresse: (map['adresse'] as String?) ?? '',
      ville: (map['ville'] as String?) ?? '',
      pays: (map['pays'] as String?) ?? '',
      visibiliteProfil: (map['visibiliteProfil'] as bool?) ?? true,
      visibiliteLocalisation: (map['visibiliteLocalisation'] as bool?) ?? true,
      profilComplet: (map['profilComplet'] as bool?) ?? false,
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'photoUrl': photoUrl,
      'promotion': promotion,
      'filiere': filiere,
      'posteActuel': posteActuel,
      'entreprise': entreprise,
      'bio': bio,
      'email': email,
      'telephone': telephone,
      'linkedin': linkedin,
      'latitude': latitude,
      'longitude': longitude,
      'adresse': adresse,
      'ville': ville,
      'pays': pays,
      'visibiliteProfil': visibiliteProfil,
      'visibiliteLocalisation': visibiliteLocalisation,
      'profilComplet': profilComplet,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
}
