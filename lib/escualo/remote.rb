module Escualo
  module Remote
    def self.attach(dir, name, session_options)
      remote_name = "escualo-#{name}-#{session_options.hostname}"
      remote_url = remote_git_url(name, session_options)
      %x{cd #{dir} && git remote add #{remote_name} #{remote_url}}
    end

    def self.remote_git_url(name, session_options)
      if session_options.local || session_options.dockerized
        "/var/repo/#{name}.git"
      else
        "ssh://#{session_options.username}@#{session_options.hostname}:#{session_options.ssh_options[:port]}/var/repo/#{name}.git"
      end
    end

    def self.clone(dir, repo, options)
      repo_url = "https://github.com/#{repo}"
      %x{git clone #{repo_url} #{dir}}
      if options.tag
        %x{cd #{dir} && git checkout #{options.tag}}
      end
    end

    def self.remotes(dir)
      %x{cd #{dir} && git remote show}
      .split
      .select {|it| it.start_with? 'escualo-'}
    end

    def self.push(dir)
      remotes(dir)
      .each do |remote|
        %x{cd #{dir} && git push #{remote} HEAD}
      end
    end
  end
end
