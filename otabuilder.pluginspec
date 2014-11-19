Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "otabuilder"
  plugin.display_name = "OTA Builder Plugin"
  plugin.version = '0.3.1'
  plugin.description = 'This plugin help you to build OTA installation packages for your XCode builds on Jenkins. It creates the manifest file, it also upload the package to a ftp server and mail the installation link to desired e-mail ids'
  
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Over-the-Air+Ad+Hoc+Deployment+Plugin+For+iOS'
  plugin.developed_by "jesly.varghese", "Jesly Varghese <jesly.varghese@gmail.com>"
  plugin.uses_repository :github => "sourcebits-jesly/otabuilder-plugin"

  plugin.depends_on 'ruby-runtime', '0.10'
end
