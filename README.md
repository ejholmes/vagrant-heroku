This is a [veewee](https://github.com/jedi4ever/veewee) template for building a
[Vagrant](http://vagrantup.com/) box that closely mirrors the heroku Cedar stack. You can build it
yourself by following the directions below or install a prebuilt version from [here](#).

## Easy install

```ruby
config.vm.box = "heroku"
config.vm.box_url = "http://domain.com/path/to/heroku.box"
```

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
$ bundle exec vagrant basebox build heroku
```

And finally, install the box for use with Vagrant.

```bash
$ bundle exec vagrant basebox export heroku
```

Now all you have to do is setup vagrant in your project.

```bash
$ bundle exec vagrant init heroku
$ bundle exec vagrant up
$ bundle exec vagrant ssh
```

## Included Packages

The packages that are included are carefully selected to closely match those on
the Celadon Cedar stack.

* Ubuntu 10.04
* Ruby 1.9.2-p180 MRI
* RubyGems 1.3.7
* PostgreSQL 8.3.14
* NodeJS 0.4.7

## Gotchas

**RubyGems Version**

Since heroku uses an older version of RubyGems (1.3.7) you may want to update
this in your environment if some of your development gems depend on a newer
version.

**PostgreSQL Credentials**

You can use the username `postgres` with a nil password. Something like this
should work:

```yaml
development:
  adapter: postgresql
  database: myapp_development
  encoding: unicode
  host: localhost
  username: postgres
  password:
```
