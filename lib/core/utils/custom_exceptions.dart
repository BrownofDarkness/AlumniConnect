class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);
  @override
  String toString() => message;
}

class LocationPermissionException implements Exception {
  final String message;
  LocationPermissionException(this.message);
  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
      : super('Email ou mot de passe incorrect');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super("Cette adresse email n'est pas valide");
}

class UserDisabledException extends AuthException {
  UserDisabledException()
      : super('Ce compte a été désactivé. Contacte un administrateur.');
}

class TooManyRequestsException extends AuthException {
  TooManyRequestsException()
      : super('Trop de tentatives. Réessaie dans quelques minutes.');
}

class SessionExpiredException extends AuthException {
  SessionExpiredException()
      : super('Ta session a expiré. Reconnecte-toi pour continuer.');
}

class OperationNotAllowedException extends AuthException {
  OperationNotAllowedException()
      : super("Cette méthode de connexion n'est pas activée. Contacte un administrateur.");
}

class NetworkException extends AuthException {
  NetworkException() : super('Pas de connexion internet. Vérifie ton réseau.');
}

class UnknownAuthException extends AuthException {
  UnknownAuthException()
      : super('Une erreur est survenue. Réessaie dans un instant.');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException()
      : super('Le mot de passe est trop faible (6 caractères minimum).');
}

class RequiresRecentLoginException extends AuthException {
  RequiresRecentLoginException()
      : super('Reconnecte-toi pour effectuer cette action sensible.');
}