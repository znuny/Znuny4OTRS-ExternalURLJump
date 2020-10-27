# Configuration

Via SysConfig-Settings

SysConfig -> Znuny4OTRS-ExternalURLJump -> Frontend::Agent::ModuleRegistration

SysConfig -> Znuny4OTRS-ExternalURLJump -> Frontend::Customer::ModuleRegistration

Just update:

* Name: Your Link Name

* Link: URL=http://host/some_page.html (only URL param)
* Link now accepts placeholders

## Placeholders

 - '_USERID_'
 - '_USERFIRSTNAME_'
 - '_USERLASTNAME_'
 - '_USERFULLNAME_'
 - '_USERLOGIN_'
 - '_USERLOGINFAILED_'
 - '_USEREMAIL_'
 - '_USERCHALLENGETOKEN_'
 - '_USERCHARSET_'
 - '_USERCOMMENT_'
 - '_USERLANGUAGE_'
 - '_USERLASTLOGIN_'
 - '_USERLASTLOGINTIMESTAMP_'
 - '_USERLASTREQUEST_'
 - '_USERREFRESHTIME_'
 - '_USERSKIN_'
 - '_USERTHEME_'
 - '_USERTIMEZONE_'
 - '_USERTIMEZONEOFFSETDIFFERENCE_'
 - '_USERTITLE_'
 - '_USERTYPE_'