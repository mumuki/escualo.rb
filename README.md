[![Build Status](https://travis-ci.org/mumuki/escualo.rb.svg?branch=master)](https://travis-ci.org/mumuki/escualo.rb)

# escualo.rb

> Ruby implementation of the mumuki's escualo provisioning tool


## Installing

```bash
$ gem install escualo
```

## Using the gem

### Simple local usage

> It will execute escualo commands in localhost context, without requiring an ssh connection

```bash
escualo bootstrap
escualo plugin install postgre
escualo artifact create service atheneum 80
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>
escualo deploy atheneum mumuki/mumuki-atheneum
```

### Remote usage

> It will connect to a remote ssh host, and exec escualo commands on it.
> Most commands accept remote options, except for the `deploy` and `remote` commands themselves

```bash
export OPTIONS='--hostname my.mumuki.host.com --username mumukiuser --ssh-port 2202'

escualo bootstrap $OPTIONS
escualo plugin install postgre $OPTIONS
escualo artifact create service atheneum 80 $OPTIONS
escualo env set <NAME1=VALUE1> <NAME2=VALUE2> $OPTIONS
escualo deploy atheneum mumuki/mumuki-atheneum
```

### Installing plugins

> Plugins let you install extra components on server, like databases and programming languages

```bash
escualo bootstrap
escualo plugin install mongo
escualo plugin install node
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>
escualo artifact create service bibliotheca 8080
escualo deploy bibliotheca mumuki/mumuki-bibliotheca
```

### Deploying multiple artifacts

> Multiple artifacts - services, executables or static sites - can be deployed on the same host

```bash
escualo bootstrap

escualo plugin install postgre
escualo plugin install haskell
escualo plugin install nginx --nginx-conf /home/user/Desktop/nginx.conf

escualo env set <NAME1=VALUE1> <NAME2=VALUE2>

escualo artifact create service atheneum 8080
escualo artifact create service haskell-runner 8081
escualo artifact create executable mulang

escualo deploy atheneum mumuki/mumuki-atheneum
escualo deploy mulang mumuki/mulang
escualo deploy haskell-runner mumuki/mumuki-haskell-runner

escualo rake db:seed
```

### Deploying local git repo

> You can also deploy the contents of your local git repository

```bash
escualo bootstrap
escualo plugin install postgre
escualo artifact create service atheneum 80
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>

escualo remote attach atheneum
escualo remote push
```

### Scripting

```bash
escualo script atheneum.standalone.escualo.yml
```

## Testing the gem

1. Clone this repository
1. `bundle install`
1. Install a `vagrant`
1. Start a the testing machine: `vagrant up` - may take several minutes
1. Run tests: `TEST_ESCUALO_WITH_VAGRANT=true bundle exec rspec`
