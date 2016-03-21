awscli
======

Installs and configures the awscli command-line tool `aws` [(the new one, supporting all AWS services)][1].

For ubuntu and debian platforms, also installs command-ine completion for the `aws` command for interactive bash shells.

Configuring
===========

##### `[:awscli][:compile_time]`

You can control when the awscli tool will be installed during the chef run, either
in the compile stage or in the converge stage.

The attribute `[:awscli][:compile_time]` defaults to `false`, meaning the awscli
will be installed during converge time. It can be set to `true` to install at compile time.
Do this if you need to use the awscli in your recipes during compile time (for example, to list
the EBS attachments of the current instance).

This cookbook will optionally configure the awscli tool. If your instance has an IAM
Role then the awscli will pick up that role's credentials automatically from the instance
metadata, so you may not need to configure the access keys. You might still want to configure the
default region.

##### `[:awscli][:config_profiles]`

The following attributes are optional and are not specified by default. If present these
will be used configure the awscli:

    [:awscli][:config_profiles]       - a hash of configuration profiles
    [:awscli][:config_profiles]<profile_key> - the name of the profile
    [:awscli][:config_profiles][<profile_key>]<option_name> = <option_value> - config options

For example, to configure the default profile, specify the following:

    'awscli': {
      'config_profiles': {
        'default' : {
          'region'               : 'us-east-1',
          'aws_access_key_id'    : 'SOMESECRET',
          'aws_secret_access_key : 'ANOTHERSECRET',
          'user'                  : 'username',
        }
      }
    }

The keys and values inside the profile_key hash are placed directly into the awscli config file.
Use this mechanism to specify additional configuration (such as output style) and additional profiles.

_Note:_ The 'user' key is an exception to the above rule. If present, the 'user' key in the profile hash specifies that that config should appear in the AWS CLI config file for that particular Unix user. This functionality is helpful if you need to configure the AWS CLI for multiple users.

##### `[:awscli][:user]`

The aws configuration is installed under the `root` user account by default.
Override this if needed;
For example, AWS ubuntu instances use the `ubuntu` user instead of `root`.
When overriding the configuration will be saved under `/home/user`.

Using
=====

If you use the awscli in your recipes, you may want to make use of the
library provided by this cookbook, InstanceMetadata. It provides a method
`wait_for_instance_IAM_metadata_to_be_available` which you may call before attempting
to use the awscli with credentials from the instance's IAM role.

Here's why: When you are running on an instance with an IAM role, the IAM credentials
are not ready until some time after the instance boots. Calling the awscli before the IAM
credentials are ready will fail.

If you specify AWS credentials in the config file, then you won't need to worry about this.

To use this library method in your cookbook:
  * Make sure your cookbook's metadata.rb has a `depends 'awscli'` entry. 
  * In your recipe, at the point where you want to wait for the IAM metadata to become available:
        `InstanceMetadata.wait_for_instance_IAM_metadata_to_be_available()`

[1]: http://aws.amazon.com/cli/
