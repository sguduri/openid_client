import 'dart:html';

import 'package:openid_client/openid_client_browser.dart';

const keycloakUri = 'http://localhost:8080/realms/myrealm';
const scopes = ['profile'];

Future<Authenticator> getAuthenticator() async {
  var uri = Uri.parse(keycloakUri);
  var clientId = 'myclient';

  var issuer = await Issuer.discover(uri);
  var client = Client(issuer, clientId);

  return Authenticator(client, scopes: scopes);
}

Future<void> main() async {
  var authenticator = await getAuthenticator();

  var credential = await authenticator.credential;

  if (credential != null) {
    final userData = await credential.getUserInfo();
    document.querySelector('#when-logged-in')!.style.display = 'block';
    document.querySelector('#name')!.text = userData.name!;
    document.querySelector('#email')!.text = userData.email!;
  } else {
    document.querySelector('#when-logged-out')!.style.display = 'block';
    document.querySelector('#login')!.onClick.listen((_) async {
      authenticator.authorize();
    });
  }
}
