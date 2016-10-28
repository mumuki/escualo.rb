[![Build Status](https://travis-ci.org/mumuki/escualo.rb.svg?branch=master)](https://travis-ci.org/mumuki/escualo.rb)

# escualo.rb

> Ruby implementation of the mumuki's escualo provisioning tool


## Installing

```bash
$ gem install escualo
```

## Using the gem

### Simple usage

```bash
escualo bootstrap --hostname <hostname>
escualo plugin install postgre
escualo artifact create service atheneum 80
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>
escualo deploy atheneum mumuki/mumuki-atheneum
```

### Installing plugins

```bash
escualo bootstrap --hostname <hostname>
escualo plugin install mongo
escualo plugin install node
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>
escualo artifact create service bibliotheca 8080
escualo deploy bibliotheca mumuki/mumuki-bibliotheca
```

### Deploying multiple services

```bash
escualo bootstrap --hostname <hostname>

escualo plugin install postgre
escualo plugin install haskell
escualo plugin install nginx --nginx-conf /home/user/Desktop/nginx.conf

escualo env set <NAME1=VALUE1> <NAME2=VALUE2>

escualo artifact create service atheneum 8080
escualo artifact create service haskell-runner 8081
escualo artifact create program mulang

escualo deploy atheneum mumuki/mumuki-atheneum
escualo deploy mulang mumuki/mulang
escualo deploy haskell-runner mumuki/mumuki-haskell-runner

escualo rake db:seed
```

### Deploying local copy

```bash
escualo bootstrap --hostname <hostname>
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
