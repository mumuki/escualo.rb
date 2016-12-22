[![Build Status](https://travis-ci.org/mumuki/escualo.rb.svg?branch=master)](https://travis-ci.org/mumuki/escualo.rb)

# escualo.rb

> Simple provisioning and deployment tool with - some -batteries included, for the typical ruby webapp.

Escualo! is a ver simple but yet powerful provisioing and deployment system, which lets you install, deploy and monitor ruby software components on a debian remote host. It is fully written in ruby, too.

It is similar to what chef, ansible or puppet does, but simpler - no agents, no recieps, no plugins. It is by no means so generic, though, but it comes with batteries included: it lets you easily add a load balancer, a message queue, a database, etc. For simple and not-so-simple deployments it works like a charm.

Escualo was originally written to deploy the Mumuki Platform, but it is a quite generic component.

## Installing

Installing escualo is reaaaaally easy :smile:. Just you need ruby installed on your machine, and run:

```bash
$ gem install escualo
```

And that's all!

## Overview

### Supported hosts

Escualo supports the following operative systems:

* Ubuntu 14.04
* Ubuntu 16.04
* Debian Jessie

### Comands

An easy way of discovering escualo commands it to run it with `--help`:

```
$ escualo --help

    artifact create executable Setup an executable command deployment
    artifact create service    Setup a micro-service deployment
    artifact create site       Setup an static site deployment
    artifact destroy           Destroys an artifact on host
    artifact list              Lists artifacts on host
    bootstrap                  Prepare environment to be an escualo host
    deploy                     Deploys repository to the given executable, service or site
    env clean                  Unset all escualo variables on host
    env list                   List escualo variables on host
    env set                    Sets one or more escualo variables on host
    env unset                  Unset escualo variables on host
    help                       Display global or [command] help documentation
    plugin install             Install plugin on host. Valid plugins are node, haskell, docker, postgre, nginx, rabbit, mongo, monit
    plugin list                List installed plugins on host
    rake                       Run rake task on host
    remote attach              Adds the given artifact to current's repository
    remote push                Pushes artifact at current repository
    remote show                Show attached artifacts to current's repository
    upload                     Upload file to host
```

Oops, that is a lot. Lets have a more general view. With `escualo` you can:

* manage artifacts: create, list and destroy deployable components, called _artifacts_. Escualo artifacts out of the box support automatic monitoring, restart on machine reboot and deploy though git.  There are three different kind of artifacts:
   * _services_: HTTP servers that listen in some port
   * _executables_: command line utilities
   * _sites_: statis sites that can be served through nginx
* bootstrap hosts: installing base esential libraries and utilities that escualo needs on the hosts.
   * It also configures host locale to `en_US.UTF-8`
* deploy escualo projects hosted on github to escualo hosts
* manage persistent environment variables
  * It stores them in the filesystem
* easily install additional software. The following are supported:
    * nginx
    * mongo
    * rabbit
    * postgresql
    * docker
    * node
    * monit

### Operation Modes

It suports three different modes:

* **Local Mode**: all the commands will run against the local machine. It is the default mode.
* **Remote Mode**: all the commands will run agains a remote machine, using ssh. This mode will be enabled when you specify any ssh option.
* **Dockerized Mode**: instead of running commands, escualo will create [Docker](https://www.docker.com/) compatible scripts, that you can easily embedd in  Dockerfile. This mode will be enabled if you set the `--dockerized` options.

Instead of a deep explanation of the gem, I will show you some usage examples. Let's begin with something easy.

## Using the gem

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

### Local usage

> It will execute escualo commands in localhost context, without requiring an ssh connection
>
> :warning: **Don't run escualo directly against your development machine**. Run it always against a virtualized environment or an fresh new production machine.
>
> :warning: Unless you know what you are doing, **don't run `bootstrap` command locally**, since it will override the ruby. This is probably not what you want on a development machine.

```bash
escualo plugin install postgre
escualo artifact create service atheneum 80
escualo env set <NAME1=VALUE1> <NAME2=VALUE2>
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

## Deploying to an escualo host from CI

### travis_setup

You need to add a `.travis.yml` configuration to your service's repo, with a few configurations. For simplicity, we have a script that solves it for you, just **make sure you run it from the project's root directory**:

```bash
./travis_setup $SERVICE_NAME $HOST1 $HOST2 ... $HOSTN
```

And that's it, just follow the instructions. :grin:

### wercker_setup

You need to add a `wercker.yml` configuration to your service's repo, with a few configurations. Also, you have to configure some things on Wercker's GUI.

* Add a deploy target named `escualo`, and set up auto deploy for `master` branch.
* Create an env variable named `ESCUALO_HOSTS`, with the comma separated list of hosts to deploy.
* Create an env variable named `ESCUALO_RSA_PRIVATE`, with the content of the `escualo_rsa` file generated by `key_gen` script.
* Add the following to your `wercker.yml file`:
```yml
deploy:
  escualo:
  - add-ssh-key:
      keyname: ESCUALO_RSA
  - script:
      name: deploy
      code: wget https://raw.githubusercontent.com/mumuki/mumuki-escualo-deploy/master/wercker_deploy && chmod u+x wercker_deploy && ./wercker_deploy $SERVICE_NAME
```

## Testing the gem

1. Clone this repository
1. `bundle install`
1. Install a `vagrant`
1. Start a the testing machine: `vagrant up` - may take several minutes
1. Run tests: `TEST_ESCUALO_WITH_VAGRANT=true bundle exec rspec`
