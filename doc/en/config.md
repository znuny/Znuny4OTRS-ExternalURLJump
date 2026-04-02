# Configuration

Use the system configuration to modify the settings of this add-on.

For the agent interface it is the setting `Frontend::Navigation###AgentExternalURLJump###1`, search for this setting or navigate to it through `Frontend` => `Agent` => `ModuleRegistration` => `MainMenu`. The setting for the customer interface is `CustomerFrontend::Navigation###CustomerExternalURLJump###1` with the same navigation path, just select `Customer` instead of `Agent`.

The part of the key `Link` that can be freely configured is the parameter `URL` value. Set this to your desired URL. The value of the URL can use one or more placeholders with the schema `_xx_` where xx could be anything from the following list.

__IMPORTANT:__ The value of parameter `URL` must be given URL encoded. If the link is e.g. `https://www.example.org/?User=Test;Language=_USERLANGUAGE_`, it has to be given as: `https%3A%2F%2Fwww.example.org%2F%3FUser%3DTest%3BLanguage%3D_USERLANGUAGE_`. Also, the configured link has to be given in exactly the following form: `Action=AgentExternalURLJump;URL=...` (agent interface) or `Action=CustomerExternalURLJump;URL=...` (customer interface).


## Ticket zoom menu (agent interface)

Up to eight optional links can appear on the ticket detail view (ticket zoom). The settings are named `Ticket::Frontend::MenuModule###001-ExternalURLJump` through `Ticket::Frontend::MenuModule###008-ExternalURLJump`. In the system configuration, open `Frontend` => `Agent` => `View` => `TicketZoom` => `MenuModule`.

These entries ship with __valid__ disabled (`Valid` off). Enable only the slots you need and adjust the label and target URL.

Main keys in the setting hash:

- **Link** – Full target URL of the external page. Template Toolkit expressions with ticket context are allowed, for example `[% Data.TicketID %]` and `[% Data.QueueID %]` (see the package defaults).
- **Action** – Must stay `AgentExternalURLJump` so the request runs through this add-on and user placeholders from the “Placeholders” section are substituted.
- **ExternalLink** – Should be `1`.
- **Name** / **Description** – Menu label and short description.
- **Group** – Optional visibility control, e.g. `rw:group1;move_into:group2`.
- **ClusterName** / **ClusterPriority** – Grouping and ordering with other ticket menu items.
- **Target** – Empty for the same browsing context; `_blank` opens a new tab (as in `###008-ExternalURLJump`).

If the target URL contains special characters or query parameters, apply the same URL encoding rules as above for navigation `URL` values.


## Placeholders

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

 Tip:  Check existing sessions via the admin interface. All keys starting with `User` can be used. Just convert them to uppercase.
