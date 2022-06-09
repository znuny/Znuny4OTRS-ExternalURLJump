# Configuration

Use the system configuration to modify the settings of this add-on.

For the agent interface it is the setting `Frontend::Navigation###ExternalURLJump###1`, search for this setting or navigate to it through `Frontend` => `Agent` => `ModuleRegistration` => `MainMenu`. The setting for the customer interface is `CustomerFrontend::Navigation###ExternalURLJump###1` with the same navigation path, just select `Customer` instead of `Agent`.

The part of the key `Link` that can be freely configured is the parameter `URL` value. Set this to your desired URL. The value of the URL can use one or more placeholders with the schema `_xx_` where xx could be anything from the following list.


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

 ::: tip :::
 Check existing sessions via the admin interface. All keys starting with `User` can be used. Just convert them to uppercase. 
 :::::::::::

