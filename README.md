# lucee_fw1_di1:

This project is intended to show how [fw/1](https://github.com/framework-one/fw1) and [di/1](https://github.com/framework-one/di1) can be used to create a basic website with some basic authentication in place that *tries* to conform to good OOP principles.

# Setup and running:

This code has been written and tested on [Lucee](http://lucee.org/) server. The easiest way to get the site up and running is via [CommandBox](https://www.ortussolutions.com/products/commandbox#download). For more documentation on `CommandBox` see the [CommandBox Manual](https://commandbox.ortusbooks.com/content/). As of this writing, the latest version of `CommandBox` is version `3.5.0`. I highly recommend downloading this version or later to follow along with the instructions in this README. Once you have `CommandBox` on your local machine, open the `CommandBox` console, navigate to folder where you have your copy of this `lucee_fw1_di1` project and then `cd` into the `app` folder. Now type your start command. For example: `start cfengine=lucee@5.1.0.034 --rewritesEnable rewritesConfig=.htaccess --debug`. This will download the version of ColdFusion server specified in the `cfengine` value and then start a localhost server (`127.0.0.1`) on a randomly assigned port number. The `--rewritesEnable rewritesConfig=.htaccess` will ensure that the localhost server uses the `.htaccess` file in the `app` folder to handle URL rewrite rules.

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