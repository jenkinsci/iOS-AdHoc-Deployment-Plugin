Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "otabuilder"
  plugin.display_name = "OTA Builder Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'This plugin help you to build OTA installation packages for your XCode builds on Jenkins. It creates the manifest file, it also upload the package to a ftp server and mail the installation link to desired e-mail ids'

  # You should create a wiki-page for your plugin when you publish it, see
  # https://wiki.jenkins-ci.org/display/JENKINS/Hosting+Plugins#HostingPlugins-AddingaWikipage
  # This line makes sure it's listed in your POM.
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Otabuilder+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "jesly.varghese", "Jesly Varghese <jesly.varghese@sourcebits.com>"

  # This specifies where your code is hosted.
  # Alternatives include:
  :github => 'sourcebits-jesly/otabuilder-plugin' (without myuser it defaults to jenkinsci)
  #:git => 'git://repo.or.cz/otabuilder-plugin.git'
  plugin.uses_repository :github => "otabuilder-plugin"

  # This is a required dependency for every ruby plugin.
  plugin.depends_on 'ruby-runtime', '0.10'

  # This is a sample dependency for a Jenkins plugin, 'git'.
  #plugin.depends_on 'git', '1.1.11'
end
