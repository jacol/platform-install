dep 'platform', :for => :linux  do
	requires 'ruby_with_gems',  'deploy.user', 'admin_tools'
end

dep 'deploy.user' do
	requires 'deploy.group', 'deploy.userkey', 'root has deploy key'
end

dep 'root has deploy key' do
	def generate_key; shell "mkdir -m 600 -p  /root/.ssh && ssh-keygen -N '' -f /root/.ssh/id_rsa -t rsa -q"; end
	def copy_root_key; shell "cat /root/.ssh/id_rsa.pub >> /home/deploy/.ssh/authorized_keys"; end
	def root_key_exist?; File.exist?("/root/.ssh/id_rsa") && File.exist?("/root/.ssh/id_rsa.pub"); end
	def deploy_has_root_key?; shell "grep `cat /root/.ssh/id_rsa.pub` /home/deploy/.ssh/authorized_keys"; end

	met? { root_key_exist? && deploy_has_root_key? }
	meet {
		generate_key unless root_key_exist?
		copy_root_key unless deploy_has_root_key?
	}
end

dep 'deploy.group'

dep 'deploy.userkey'
