![Znuny logo](https://www.znuny.com/assets/images/logo_small.png)

![Build status](https://badge.proxy.znuny.com/Znuny4OTRS-ExternalURLJump/rel-7_3)

External URL Jump
=================
With this add-on you get the possibility to add menu items with links to external URLs in the navigation bar of the agent and customer interface.

**Prerequisites**

- Znuny 7.3

**Installation**

Use the online repository **Znuny Open Source Add-ons** from the package manager to install the add-on. From the command line use this command: `bin/znuny.Console.pl Admin::Package::Install  https://addons.znuny.com/public/:Znuny-ExternalURLJump`


**Configuration**

Via system configuration settings:

* Znuny-ExternalURLJump -> Frontend::Agent::ModuleRegistration
* Znuny-ExternalURLJump -> Frontend::Customer::ModuleRegistration

Just update:

* Name: Your link name
* Link: `URL=http://host/some_page.html` (only URL param)

**Commercial Support**

For this add-on and for Znuny in general visit [www.znuny.com](https://www.znuny.com). Looking forward to hear from you.


Your Znuny Team!

[https://www.znuny.com](https://www.znuny.com)
