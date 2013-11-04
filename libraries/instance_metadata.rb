module InstanceMetadata

  @metadata_ready = false
  
  def self.wait_for_instance_IAM_metadata_to_be_available()
    unless @metadata_ready
      loop do
        wget = Mixlib::ShellOut.new("wget -q -O - 'http://169.254.169.254/latest/meta-data/iam/info/'").run_command
        if wget.exitstatus && wget.stdout.length > 1
          Chef::Log.info("Instance IAM metadata is available.")
          @metadata_ready = true
          break
        else
          Chef::Log.debug("Waiting 2 more seconds for instance IAM metadata to be available...")
          sleep 2
        end
      end
    end
  end
  
end
