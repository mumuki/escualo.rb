module Escualo
  module Remote
    def self.attach(session, dir, name, session_options)
      remote_name = "escualo-#{name}-#{session_options.hostname}"
      remote_url = remote_git_url(name, session_options)
      session.tell! "cd #{dir} && git remote add #{remote_name} #{remote_url}"
    end

    def self.remote_git_url(name, session_options)
      if session_options.local || session_options.dockerized
        "/var/repo/#{name}.git"
      else
        "ssh://#{session_options.username}@#{session_options.hostname}:#{session_options.ssh_options[:port]}/var/repo/#{name}.git"
      end
    end

    def self.clone(session, dir, repo, options)
      repo_url = "https://github.com/#{repo}"
      session.tell! "git clone #{repo_url} #{dir}"
      if options.tag
        session.tell! "cd #{dir} && git checkout #{options.tag}"
      end
    end

    def self.remotes(session, dir)
      session
          .ask("cd #{dir} && git remote show")
          .split
          .select { |it| it.start_with? 'escualo-' }
    end

    def self.push(session, dir)
      remotes(session, dir).each do |remote|
        session.tell! "cd #{dir} && git push #{remote} HEAD"
      end
    end

    def self.simple_push(session, dir)
      session.tell! "cd #{dir} && for r in $(git remote); do git push $r HEAD; done"
    end
  end
end
