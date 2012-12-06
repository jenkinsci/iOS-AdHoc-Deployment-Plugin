##Over-the-Air Ad Hoc Deployment Plugin For iOS

The OTA Builder & Uploader Plugin automates the process of building the OTA package for your XCode Project, Uploading it and Mailing the client. The plugin is built on JRuby.

###What it does?
The working of this plugin can be summarized like this.

*   Get from you some details about your apps, like path to location of ipa file, icon file location, bundle identifier and version, ftp and gmail credentials as well as reciever mail ids
*   It executes after the .ipa file get built, so this plugin works in  with [XCode Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Xcode+Plugin)
*   Once the XCode plugin finishes it's work successfully, the plugin get the .ipa file, and build the Manifest.plist for your app, so OTA Transmission is possible.
*   Uploads the .ipa,icon file and manifest file to your ftp server, and with the help of http translation data generate the itms link for your app.
*   Email the given list of people the link, so they can install the app on their device in a click.
*   Optionally you can customize the mail that is to be sent, or leave it blank, the default mail will be sent.

###How it looks?

![OTA Plugin Screnshot](https://raw.github.com/sourcebits-jesly/otabuilder-plugin/master/resources/screenshot.png "Screenshot of OTA Builder in Jenkins Project Configuration Page")

###What needs to be done to have the plugin on my machine?

*  First you need to have, [ruby-runtime-plugin](https://github.com/jenkinsci/ruby-runtime-plugin) installed in your Jenkins Server.
*  Install jruby [1.6.7](http://jruby.org/2012/02/22/jruby-1-6-7) on your system.
*  [Clone](github-mac://openRepo/https://github.com/sourcebits-jesly/otabuilder-plugin) this project.
*  Have bundler gem installed 
     
     `$gem install bundler --version 1.1.0`
*  Run bundle install in the otabuilder-plugin clone directory
     
     `$bundle install` 
*  Run jpi build
     
     `$jpi build`
*  You will, have a `pkg` folder generated.
*  Go to Jenkins and `Manage Jenkins>Advanced>Upload Plugin` and Uploaf the .hpi file
*  In `Manage Jenkins>Advanced>Installed` to the end you will see and option to restart jenkins, do it.
*  The plugin is installed, now you can add it as a post-build action for your XCode Projects.

###What more needs to be done in development?

*  Create a Jenkins Wiki for the plugin
*  Upload the build to Jenkins Plugin Repository.
*  Refactor the mailing system, now it uses URL Call, need to integrate it alongside with Jenkins.
*  Need to generalize the code and design better.

###How to contribute?

Go ahead and [fork](https://github.com/sourcebits-jesly/otabuilder-plugin/fork_select) this!

##License

[MIT License](http://mit-license.org/)
