# lucee_fw1_di1:

*Note: This project is still in development and is not complete yet.*

This project is intended to show how [fw/1](https://github.com/framework-one/fw1) and [di/1](https://github.com/framework-one/di1) can be used to create a basic website with some basic authentication in place that *tries* to conform to good OOP principles.

# Setup and running:

*Note: the following instructions are meant for getting this repository project running on your local machine. Setup may vary for dev and production machines*

This code has been written and tested on [Lucee](http://lucee.org/) server. The easiest way to get the site up and running is via [CommandBox](https://www.ortussolutions.com/products/commandbox#download). For more documentation on CommandBox see the [CommandBox Manual](https://commandbox.ortusbooks.com/content/). As of this writing, the latest version of CommandBox is 3.5.0. I highly recommend downloading this version or newer to follow along with the instructions in the instructions I describe here.

Once you have CommandBox on your local machine, open the CommandBox console and navigate to the folder where you have your copy of this `lucee_fw1_di1` project. Now type `install`. CommandBox will use the `box.json` file in the top level of the repository directory structure to download and install the project dependencies for you (currently [TestBox](https://www.ortussolutions.com/products/testbox) and [fw/1](https://github.com/framework-one/fw1))

Once the dependencies are installed, type `cd webroot` to navigate into the `webroot` folder. Now type your start command to start an instance of the Lucee server for the project. For example:

`start cfengine=lucee@5.1.0.034 --rewritesEnable rewritesConfig=.htaccess --debug`

The command above will download the version of ColdFusion server specified in the `cfengine` value and then start a localhost server (`127.0.0.1`) on a randomly assigned port number. The `--rewritesEnable rewritesConfig=.htaccess` will ensure that the localhost server uses the `.htaccess` file in the `webroot` folder to handle URL rewrite rules. The `--debug` flag will log the server start up processes within the CommandBox console until the server has finished starting up and you website is ready for browsing.

Next, you will need to setup your database. The database creation scripts can be found in the `sql` folder in the top level of the repository directory structure. At present, only PostgreSQL is supports. Other database vendors will be added in due course (pull requests welcome :smile:).

Once your database has been created, you need to sign in to the **Lucee Web Admin**. Add `lucee/admin/web.cfm` to the end of your running website's URL (e.g. `http://127.0.0.1:58248/lucee/admin/web.cfm` - your port number may be different to the one shown here). If this is your first time viewing the admin, you will be prompted for a password and a password confirmation. Otherwise you will just be asked to enter the password you used when doing this previously. Once signed in, click on **Datasource** in the left navigation (underneath **Services**). Now create your new datasource and point it to the database you created from the script above. If you are simply following along with this example app, use `lucee_fw1_di1` as the datasource name. If you choose to name it something else, you will need to update the relevant `dsn` values in the config files inside the `config` folder in the top level of the repository directory structure.

You will also need to add some mappings in the admin. Click on **Mappings** in the left navigation (underneath **Archives & Resources**). Now add the following mappings:

| framework-one: ||
|---|---|
| Virtual | `/framework` |
| Resource | `../framework` |

| TestBox: ||
|---|---|
| Virtual | `/testbox` |
| Resource | `../testbox` |

| Actual tests: ||
|---|---|
| Virtual | `/tests` |
| Resource | `../tests` |

You will also see that the aliases for running static files with the **testbox** and **tests** folders have been included in the `webroot/server.json` file. For a Lucee production server installation, these aliases will need to be mapped in your relevant server files (e.g. within apache itself).

## base62Alphabet:
[base62Alphabet](https://github.com/ryanguill/cfmlBase62)

## Google's reCaptcha
[reCaptcha](https://www.google.com/recaptcha)

# Tests:

Unit tests can be found inside the `tests` folder.

The easiest way to run the tests is by using [TestBox](https://www.ortussolutions.com/products/testbox). The following instructions may have changed since this writing and you may want to check the official website instead of these instructions. To install `TestBox`, open your `CommandBox` console on you local machine, navigate into the `lucee_fw1_di1` project root folder, and type `box install testbox`. This should pull down all the necessary files into a folder called `testbox` inside the project root. I have excluded this folder in the `.gitignore` file so that it doesn't accidentally get included in your own repository in the future.

# Disclaimers:

This SOFTWARE PRODUCT is provided by THE PROVIDER "as is" and "with all faults." THE PROVIDER makes no representations or warranties of any kind concerning the safety, suitability, lack of viruses, inaccuracies, typographical errors, or other harmful components of this SOFTWARE PRODUCT. There are inherent dangers in the use of any software, and you are solely responsible for determining whether this SOFTWARE PRODUCT is compatible with your equipment and other software installed on your equipment. You are also solely responsible for the protection of your equipment and backup of your data, and THE PROVIDER will not be liable for any damages you may suffer in connection with using, modifying, or distributing this SOFTWARE PRODUCT.

# Copyright and Licence:

Copyright (c) 2016-2017 Andrew Jackson (and others -- see individual files for additional copyright holders). All rights reserved. The use and distribution terms for this software are covered by the Apache Software License 2.0 (http://www.apache.org/licenses/LICENSE-2.0) which can also be found in the file LICENSE at the root of this distribution and in individual licensed files. By using this software in any fashion, you are agreeing to be bound by the terms of this license. You must not remove this notice, or any other, from this software.