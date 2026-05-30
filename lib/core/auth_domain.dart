import 'package:firebase_auth/firebase_auth.dart';

/// Domínio institucional permitido para acessar o app.
const String allowedEmailDomain = '@souunit.com.br';

/// Mensagem mostrada quando o e-mail não é do domínio institucional.
const String domainErrorMessage =
    'Acesso permitido apenas para contas $allowedEmailDomain.';

/// Confere se o usuário logado tem e-mail do domínio institucional.
/// Se não tiver, faz logout imediato e retorna false.
Future<bool> isAllowedDomainOrSignOut() async {
  final email = FirebaseAuth.instance.currentUser?.email ?? '';
  if (email.toLowerCase().endsWith(allowedEmailDomain)) {
    return true;
  }
  await FirebaseAuth.instance.signOut();
  return false;
}
