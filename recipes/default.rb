# installs Amazon's awscli tools

case node[:platform]
when 'debian', 'ubuntu'
  file = '/usr/local/bin/aws'
  cmd = 'apt-get install -y python-pip && pip install awscli'
  completion_file = '/etc/bash_completion.d/aws'
when 'redhat', 'centos', 'fedora', 'amazon', 'scientific'
  file = '/usr/bin/aws'
  cmd = 'yum -y install python-pip && pip install awscli'
end
r = execute 'install awscli' do
  command cmd
  not_if { ::File.exist?(file) }
  if node[:awscli][:compile_time]
    action :nothing
  end
end
if node[:awscli][:compile_time]
  r.run_action(:run)
end

if node[:awscli][:config_profiles]
  default_user = node[:awscli][:user]
  config_profiles_by_user = node[:awscli][:config_profiles].inject({}) do |hash, (profile_name, config_profile)|
    config_profile = config_profile.dup
    user = config_profile.delete(:user) || default_user
    config_profiles = hash[user] ||= {}
    config_profiles[profile_name] = config_profile
    hash
  end

  config_profiles_by_user.each do |(user, config_profiles)|
    if user == 'root'
      config_file = "/#{user}/.aws/config"
    else
      config_file = "/home/#{user}/.aws/config"
    end

    r = directory ::File.dirname(config_file) do
      recursive true
      owner user
      group user
      mode 00700
      not_if { ::File.exist?(::File.dirname(config_file)) }
      if node[:awscli][:compile_time]
        action :nothing
      end
      if not node[:awscli][:compile_time]
        action :create
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
      variables(
        config_profiles: config_profiles,
      )
      if node[:awscli][:compile_time]
        action :nothing
      end
      if not node[:awscli][:compile_time]
        action :create
      end
    end
    if node[:awscli][:compile_time]
      r.run_action(:create)
    end
  end
end

unless completion_file.nil?
  file completion_file do
    action :create_if_missing
    mode 00644
    owner 'root'
    group 'root'
    # newline is important
    content 'complete -C aws_completer aws'
  end
end
