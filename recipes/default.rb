# installs Amazon's awscli tools

case node[:platform]
when 'debian','ubuntu'
  file = "/usr/local/bin/aws"
  cmd = "apt-get install -y python-pip && pip install awscli"
  completion_file='/etc/bash_completion.d/aws'
when 'redhat','centos','fedora','amazon','scientific'
  file = "/usr/bin/aws"
  cmd = "yum -y install python-pip && pip install awscli"
end
r = execute "install awscli" do
  command cmd
  not_if { ::File.exists?(file) }
  if node[:awscli][:compile_time]
    action :nothing
  end
end
if node[:awscli][:compile_time]
  r.run_action(:run)
end

if node[:awscli][:config_profiles]
  user = node[:awscli][:user]
  if user == "root"
    config_file="/#{user}/.aws/config"
  else
    config_file="/home/#{user}/.aws/config"
  end

  r = directory ::File.dirname(config_file) do
    recursive true
    owner user
    group user
    mode 00700
    not_if { ::File.exists?(::File.dirname(config_file)) }
    if node[:awscli][:compile_time]
      action :nothing
    end
  end
  if node[:awscli][:compile_time]
    r.run_action(:create)
  end

  r = template config_file do
    mode 00600
    owner user
    group user
    source 'config.erb'
    not_if { ::File.exists?(config_file) }
    if node[:awscli][:compile_time]
      action :nothing
    end
  end
  if node[:awscli][:compile_time]
    r.run_action(:create)
  end
end

unless completion_file.nil?
  file completion_file do
    action :create_if_missing
    mode 00644
    owner 'root'
    group 'root'
    # newline is important
    content "complete -C aws_completer aws
"
  end
end
