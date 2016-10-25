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
escualo install postgre
escualo create service atheneum 80
escualo vars set <NAME1=VALUE1> <NAME2=VALUE2>
escualo deploy atheneum mumuki/mumuki-atheneum
```

### More advanced usages

```bash
escualo bootstrap --hostname <hostname>
escualo install mongo
escualo install node
escualo vars set <NAME1=VALUE1> <NAME2=VALUE2>
escualo create service bibliotheca 8080
escualo deploy bibliotheca mumuki/mumuki-bibliotheca
```

```bash
escualo bootstrap --hostname <hostname>

escualo install postgre
escualo install haskell
escualo install nginx --nginx-conf /home/user/Desktop/nginx.conf

escualo vars set <NAME1=VALUE1> <NAME2=VALUE2>

escualo create service atheneum 8080
escualo create service haskell-runner 8081
escualo create program mulang

escualo deploy atheneum mumuki/mumuki-atheneum
escualo deploy mulang mumuki/mulang
escualo deploy haskell-runner mumuki/mumuki-haskell-runner

escualo rake db:seed
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
1. Run tests: `bundle exec rspec`
