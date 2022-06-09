# Konfiguration

Alle Einstellungen für dieses Add-on sind über die System-Konfiguration vorzunehmen.

Für die Agentenoberfläche ist es die Einstellung `Frontend::Navigation###ExternalURLJump###1`, suchen Sie nach dieser Einstellung oder navigieren Sie zu ihr über `Frontend` => `Agent` => `ModuleRegistration` => `MainMenu`. Die Einstellung für die Kundenschnittstelle ist `CustomerFrontend::Navigation###ExternalURLJump###1` mit dem gleichen Navigationspfad, wählen Sie aber `Customer` statt `Agent`.

Der Teil des Schlüssels `Link`, der frei konfiguriert werden kann, ist der Wert des Parameters `URL`. Setzen Sie diesen auf die gewünschte URL. Der Wert der URL kann einen oder mehrere Platzhalter mit dem Schema `_xx_` verwenden, wobei xx alles aus der folgenden Liste sein kann.


## Platzhalter

 - `_USERID_`
 - `_USERFIRSTNAME_`
 - `_USERLASTNAME_`
 - `_USERFULLNAME_`
 - `_USERLOGIN_`
 - `_USERLOGINFAILED_`
 - `_USEREMAIL_`
 - `_USERCHALLENGETOKEN_`
 - `_USERCHARSET_`
 - `_USERCOMMENT_`
 - `_USERLANGUAGE_`
 - `_USERLASTLOGIN_`
 - `_USERLASTLOGINTIMESTAMP_`
 - `_USERLASTREQUEST_`
 - `_USERREFRESHTIME_`
 - `_USERSKIN_`
 - `_USERTHEME_`
 - `_USERTIMEZONE_`
 - `_USERTIMEZONEOFFSETDIFFERENCE_`
 - `_USERTITLE_`
 - `_USERTYPE_`

Tipp:  Überprüfen Sie bestehende Sitzungen über die Verwaltungsoberfläche. Alle Schlüssel, die mit `User` beginnen, können verwendet werden. Konvertieren Sie sie einfach in Großbuchstaben.