name             'awscli'
maintainer       'Shlomo Swidler'
maintainer_email 'shlomo.swidler@orchestratus.com'
license          'Apache 2.0'
description      'Installs the AWS command line tools'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

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
  
attribute 'awscli/aws_access_key_id',
  :display_name => "AWS Access Key Id",
  :description => "The access key ID. Used to configure the awscli tool.",
  :default => "nil",
  :type => "string",
  :required => "optional",
  :recipes => [ "awscli::default" ]
  
attribute 'awscli/aws_access_key_id',
  :display_name => "AWS Secret Access Key",
  :description => "The secret access key. Used to configure the awscli tool.",
  :default => "nil",
  :type => "string",
  :required => "optional",
  :recipes => [ "awscli::default" ]

attribute 'awscli/default_region',
  :display_name => "Default AWS region",
  :description => "The default AWS region. Used to configure the awscli tool.",
  :default => "nil",
  :type => "string",
  :required => "optional",
  :recipes => [ "awscli::default" ]
  
