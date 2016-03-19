TOT2
====

An Apple OTA server, includes a server to upload beta test ipa packages and a web app to let others download beta test ipa packages.

#Features
1.Dynamic manifest technology, sqlite and local file storage makes server migration be easy.  
2.Management of apps.  
3.Management of users and permissions.  

#What's new
App management.  
User and permission management.  

#It's a Rails app
Created in rails 3.2.13, tested in rails 3.2.13 and rails 4.0  

Use [devise](https://github.com/plataformatec/devise) 3.0.0  
Use [cancan](https://github.com/ryanb/cancan) 1.6.10  
Use [rubyzip](https://github.com/rubyzip/rubyzip) 0.9.9  
Use [CFPropertyList](https://github.com/ckruse/CFPropertyList) 2.2.0  
Use [bootstrap](http://getbootstrap.com/)  
Use [pngdefry](http://www.jongware.com/pngdefry.html)  
Use sqlite 3  

#How to use

#### 1.Download TOT2 or clone it to your server.  

```
$ git clone https://github.com/OpenFibers/TOT2.git
```

#### 2.Init the rails server

```
$ cd TOT2
$ ./tot setup
```

A default admin account with email: ***tot@tot.com***, password: ***totadmin*** will be generated.

#### 3.Start the rails server

```
$ ./tot start
```
Run this script at server start time to make the TOT2 server keep alive.  

You may want to config SSL certificate:  

```
./tot start --ssl --ssl-verify --ssl-key-file ssllocal/server.key --ssl-cert-file ssllocal/server.crt
```

Or another server port:

```
$ ./tot start -p 3001
```

More server options, check:

```
$ thin --help
```

#### 4.Upload ipa and dSYM files  

Open [http://your-ip-or-host-of-rails-server:3000/admin](http://your-ip-or-host-of-rails-server:3000/admin)  
Login use default admin account with email: ***tot@tot.com***, password: ***totadmin***.  

![Login](https://raw.github.com/OpenFibers/TOT2/master/ScreenShots/1.login.png)

Click 'Upload' in the top of the admin page.  
Upload ipa and dSYM files.  

![Upload](https://raw.github.com/OpenFibers/TOT2/master/ScreenShots/2.upload.png)

***We strongly suggest that register a new user and award permissions to users, instead of manage apps use default admin account.***  

Then you can see your uploaded apps in 'Apps' tab.

![Manage App](https://raw.github.com/OpenFibers/TOT2/master/ScreenShots/3.manageapp.png)

#### 5.Download apps in iOS devices

Open [http://your-ip-or-host-of-rails-server:3000](http://your-ip-or-host-of-rails-server:3000) on iOS devices.  
Download apps.  

![Download List](https://raw.github.com/OpenFibers/TOT2/master/ScreenShots/4.downloadlist.png)

![Download](https://raw.github.com/OpenFibers/TOT2/master/ScreenShots/5.download.png)

#### 6.If no SSL certificate configured for TOT2 server

* In app version's edit page of admin panel, download the manifest file.
* Upload manifest file to some cloud drive which supports HTTPS external links, like DropBox, then share the manifest file and get the shared link.
* Set the shared link in 'External Manifest URL', click 'Confirm Change'.
* Download the beta-test app from devices.

#### 7.Stop TOT2 server

```
$ ./tot stop
```

#### 8.Config mail sender

Open 'config/initializers/devise.rb', change the code below

```
config.mailer_sender = "please-change-me-at-config-initializers-devise-and-config-environment@gmail.com"
```

to

```
config.mailer_sender = "your-email-address@gmail.com"
```

Then open 'config/environment.rb', change the code below

```
-    :user_name => "please-change-me-at-config-initializers-devise-and-config-environment@gmail.com",
-    :password => 'yourpassword'
```

to

```
+    :user_name => "your-email-address@gmail.com",
+    :password => 'yourpassword'
```

#### 9.Reset admin account if forgot

Just run ***rake db:seed*** to reset default account:

```
$ cd TOT2
$ ./tot reset rootuser
```

Restart server, then you can login the TOT2 admin page, [http://your-ip-or-host-of-rails-server:3000/admin] with email: ***tot@tot.com***, password: ***totadmin***.

#### 10.Reset data base.  

```
$ cd TOT2
$ ./tot reset db
```
Database will be reseted after restart, including apps and users data.

#How to migrate TOT2 server
Just copy the entire TOT2 folder to another server.

#Other choice

Web Service:  
1.[Test Flight](http://testflightapp.com)  
2.[diawi](http://www.diawi.com)  
3.[AppSendr](http://www.appsendr.com)  
4.[HockeyApp](http://www.hockeyapp.net)  
  
Open Sourced project:  
1.[HockeyKit](https://github.com/TheRealKerni/HockeyKit) : Open sourced PHP5 project.  
2.[BetaBuilder for iOS](http://www.hanchorllc.com/betabuilder-for-ios/) : Open sourced native MAC app. It should be used with a static web server.  
