This is a [veewee](https://github.com/jedi4ever/veewee) template for building a
[Vagrant](http://vagrantup.com/) box that closely mirrors the heroku Cedar stack. You can build it
yourself by following the directions below or install a prebuilt version from [here](http://dl.dropbox.com/u/1906634/heroku.box).

## Easy install

Add the following to your `Vagrantfile`.

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "heroku"
  config.vm.box_url = "http://dl.dropbox.com/u/1906634/heroku.box"
end
```

And run `vagrant up`. The box will be downloaded and imported for you.

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
$ bundle exec veewee vbox build heroku
```

And finally, install the box for use with Vagrant.

```bash
$ bundle exec veewee vbox export heroku
$ vagrant box add heroku heroku.box
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

* Ubuntu 10.04 64bit
* Ruby 1.9.2-p392 MRI
* RubyGems 1.8.23
* Python with pip, virtualenv, and virtualenvwrapper
* PostgreSQL 9.2.4
* NodeJS 0.4.7
* Foreman https://github.com/ddollar/foreman
