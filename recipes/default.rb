# installs Amazon's awscli tools

case node[:platform]
when 'debian','ubuntu'
  file = "/usr/local/bin/aws"
  cmd = "apt-get install -y python-pip && pip install awscli"
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
