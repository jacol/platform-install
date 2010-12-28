dep 'xenia' do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs', 'xenia_app', 'xenia.webservice'
	
	met? { File.directory? "/opt/xenia/current" }
	meet {
		git "git://git.anixe.pl/xenia.git" do |path|
			log_shell "Capistrano setup", "cap deploy:setup HOSTS=127.0.0.1"
			log_shell "Capistrano deploy", "cap deploy HOSTS=127.0.0.1"
		end
	}
end

dep 'xenia_app' do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs'
end

dep 'xenia_etc_environment' do
	met? { shell "grep XENIA_CFG /etc/environment" }
	meet { append_to_file 'XENIA_CFG=fti', '/etc/environment', :sudo => true }
end

dep 'xenia.dirs' do
	requires 'deploy.user', 'deploy.userkey', 'deploy.group'
	dirs '/var/data/xenia', '/var/log/xenia', '/var/data/export', '/opt/xenia', '/opt/xenia/releases', '/opt/xenia/shared', '/opt/xenia/shared/system',  '/opt/xenia/shared/log',  '/opt/xenia/shared/pids'
	user 'deploy'
	group 'deploy'
	mask '2774'			# drwrwxs--
end

dep 'xenia.webservice' do
	requires 'deploy.user'
end
