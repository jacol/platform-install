dep 'gitosis.server' do
	requires 'gitosis'
end

# installation according to this help http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way
dep 'gitosis' do
	requires 'python-setuptools.managed', 'git-core.managed', 'git.user'
	helper(:post_update) { "/home/git/repositories/gitosis-admin.git/hooks/post-update" }
	helper(:post_update_executable?) { File.lstat(post_update).mode.to_s(8) =~ /755/ } 
	
	met? { File.exists? "/home/git/repositories/gitosis-admin.git" and 
		post_update_executable?
 		}
	meet do
    git "git://eagain.net/gitosis.git" do |path|
      log_shell "Setting up gitosis", "python setup.py install"
    end

		sudo "echo '#{var(:pub_key)}' > /tmp/id_rsa.pub && sudo -H -u git gitosis-init < /tmp/id_rsa.pub" 
		sudo "chmod 755 #{post_update}" unless post_update_executable?
	end
end

dep 'git.user' do
	meet { sudo "adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git" }
end

dep 'python-setuptools.managed' do
	provides 'python'
end

dep 'git-core.managed' do
	provides 'git'
end