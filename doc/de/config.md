# Konfiguration

Alle Einstellungen für dieses Add-on sind über die System-Konfiguration vorzunehmen.

Für die Agentenoberfläche ist es die Einstellung `Frontend::Navigation###AgentExternalURLJump###1`, suchen Sie nach dieser Einstellung oder navigieren Sie zu ihr über `Frontend` => `Agent` => `ModuleRegistration` => `MainMenu`. Die Einstellung für die Kundenschnittstelle ist `CustomerFrontend::Navigation###CustomerExternalURLJump###1` mit dem gleichen Navigationspfad, wählen Sie aber `Customer` statt `Agent`.

Der Teil des Schlüssels `Link`, der frei konfiguriert werden kann, ist der Wert des Parameters `URL`. Setzen Sie diesen auf die gewünschte URL. Der Wert der URL kann einen oder mehrere Platzhalter mit dem Schema `_xx_` verwenden, wobei xx alles aus der folgenden Liste sein kann.

__WICHTIG:__ Der Wert des Parameters `URL` muss URL-encodiert hinterlegt werden. Wenn der Link z. B. `https://www.example.org/?User=Test;Language=_USERLANGUAGE_` lautet, so muss folgender Wert dafür eingetragen werden: `https%3A%2F%2Fwww.example.org%2F%3FUser%3DTest%3BLanguage%3D_USERLANGUAGE_`. Außerdem muss der konfigurierte Link in exakt folgender Form angegeben werden: `Action=AgentExternalURLJump;URL=...` (Agentenoberfläche) bzw. `Action=CustomerExternalURLJump;URL=...` (Kundenoberfläche).


## Ticket-Zoom-Menü (Agentenoberfläche)

Bis zu acht optionale Links können in der Ticket-Detailansicht (Ticket-Zoom) erscheinen. Die zugehörigen Einstellungen heißen `Ticket::Frontend::MenuModule###001-ExternalURLJump` bis `Ticket::Frontend::MenuModule###008-ExternalURLJump`. In der Systemkonfiguration finden Sie sie unter `Frontend` => `Agent` => `View` => `TicketZoom` => `MenuModule`.

Diese Einträge sind im Paket standardmäßig __ungültig__ (`Valid` deaktiviert). Aktivieren Sie nur die Nummern, die Sie nutzen möchten, und bearbeiten Sie Anzeigetext sowie Ziel-URL.

Die wichtigsten Schlüssel im Hash der Einstellung:

- **Link** – Vollständige Ziel-URL der externen Seite. Erlaubt sind Template-Toolkit-Ausdrücke mit Ticket-Kontext, z. B. `[% Data.TicketID %]` und `[% Data.QueueID %]` (siehe mitgelieferte Beispielwerte).
- **Action** – Muss `AgentExternalURLJump` bleiben, damit die Anfrage über dieses Add-on läuft und die Benutzer-Platzhalter aus dem Abschnitt „Platzhalter“ ersetzt werden.
- **ExternalLink** – Soll `1` sein.
- **Name** / **Description** – Beschriftung im Menü und Kurzinfo.
- **Group** – Optional; Sichtbarkeit z. B. im Stil `rw:Gruppe1;move_into:Gruppe2`.
- **ClusterName** / **ClusterPriority** – Gruppierung und Sortierung neben anderen Ticket-Menüeinträgen.
- **Target** – Leer für gleichen Kontext; `_blank` öffnet in einem neuen Tab (vorgegeben bei `###008-ExternalURLJump`).

Enthält die Ziel-URL Sonderzeichen oder Abfrageparameter, gilt dieselbe Anforderung zur URL-Kodierung wie oben für den `URL`-Parameter der Navigationslinks.


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
