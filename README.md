# Vagrant Heroku

This is a [veewee](https://github.com/jedi4ever/veewee) template for building a
[Vagrant](http://vagrantup.com/) box that closely mirrors the heroku Cedar stack. You can build it
yourself by following the directions below or install a prebuilt version from [here](#).

## Building From Scratch

First, clone the repo and install gems with bundler.

```bash
$ git clone git@github.com:ejholmes/vagrant-heroku.git
$ cd vagrant-heroku
$ bundle install
```

Next, build the box with veewee. Go grab a cup of coffee because this is gonna
take a while.

```bash
$ vagrant basebox build heroku
```

And finally, install the box for use with Vagrant.

```bash
$ vagrant basebox export heroku
```

Now all you have to do is setup vagrant in your project.

```bash
$ vagrant init heroku
$ vagrant up
$ vagrant ssh
```

## Included Packages

The packages that are included are carefully selected to closely match those on
the Celadon Cedar stack.

* Ubuntu 10.04
* Ruby 1.9.2-p180 MRI
* RubyGems 1.3.7
* PostgreSQL 8.3.11
