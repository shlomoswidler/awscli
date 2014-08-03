name             'awscli'
maintainer       'Shlomo Swidler'
maintainer_email 'shlomo.swidler@orchestratus.com'
license          'Apache 2.0'
description      'Installs the AWS command line tools'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.0'

recipe "default", "Install AWS CLI tools"

%w{redhat centos fedora amazon scientific debian ubuntu}.each do |plat|
 supports plat
end

attribute 'awscli/compile_time',
  :display_name => "Compile Time",
  :description => "Whether to install the awscli tool during chef compile time or not",
  :default => "false",
  :type => "string",
  :required => "optional",
  :recipes => [ "awscli::default" ]
  
attribute 'awscli/config_profiles',
  :display_name => "Configuration Profiles",
  :description => "A hash of profile names to hashes of key-value pairs specifying configuration options",
  :default => "nil",
  :type => "hash",
  :required => "optional",
  :recipes => [ "awscli::default" ]
