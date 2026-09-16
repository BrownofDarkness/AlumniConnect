class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return "L'adresse email est requise";
    if (!_emailRegex.hasMatch(v)) return "Cette adresse email n'est pas valide";
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Le mot de passe est requis';
    return null;
  }

  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) return 'Le mot de passe est requis';
    if (value.length < 8) return 'Au moins 8 caractères sont requis';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Une majuscule est requise';
    if (!RegExp(r'\d').hasMatch(value)) return 'Un chiffre est requis';
    return null;
  }

  static String? notEmpty(String? value, String fieldMessage) {
    if (value == null || value.trim().isEmpty) return fieldMessage;
    return null;
  }
}
