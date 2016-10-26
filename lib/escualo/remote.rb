module Escualo
  module Remote
    def self.attach(dir, name)
      remote_name = "escualo-#{name}-#{$hostname}"
      remote_url = "ssh://#{$username}@#{$hostname}:#{$ssh_options[:port]}/var/repo/#{name}.git"
      %x{cd #{dir} && git remote add #{remote_name} #{remote_url}}
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
