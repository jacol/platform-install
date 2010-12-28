dep 'xenia' do
	requires 'platform', 'xenia_etc_environment', 'xenia.dirs', 'xenia_app', 'xenia.webservice'
	
	met? { File.directory? "/opt/xenia/current" }
	meet {
		dir = ""
		in_build_dir {|path|
			log_shell "Cloning repo", " git clone --depth 1 git://git.anixe.pl/xenia.git && rvm rvmrc trust #{File.join(path, "xenia")}"
			log_shell "Deploying", "cd xenia && cap deploy HOSTS=127.0.0.1"
		}
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
	requires 'deploy.user', 'xenia symlink exists'
end

dep 'xenia symlink exists' do
	met? { FileTest.symlink?("/var/www/root/xenia") }
  meet { sudo "ln -f -s /opt/xenia/current/public/ /var/www/root/xenia" }
end
