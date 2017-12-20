#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'java-1.8.0-openjdk.x86_64' do
  action :install
end
remote_file '/opt/apache-tomcat-8.5.24.tar.gz' do
  source 'http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz'
end

group 'tomcat' do
  action :create
end

"userpass"="data_bag_item("tomcat-secrt","krishna")"
user 'tomcat' do
  manage_home false
  home '/opt/apache-tomcat-8.5.24'
  shell '/bin/false'
  group 'tomcat'
  password userpass["password"]
   action :create
end

execute 'tar xvfz /opt/apache-tomcat-8.5.24.tar.gz -C /opt' do
  not_if {File.exist?('/opt/apache-tomcat-8.5.24')}
end

execute 'chown -R tomcat:tomcat /opt/apache-tomcat-8.5.24'
#directory "/opt/apache-tomcat-8.5.24" do 
#  owner 'tomcat'
#  group 'tomcat'
#  recursive true
#end
template '/opt/apache-tomcat-8.5.24/conf/tomcat-users.xml' do
  source 'default.erb'
  owner 'tomcat'
  group 'tomcat'
end
execute '/opt/apache-tomcat-8.5.24/bin/startup.sh'
