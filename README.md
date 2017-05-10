# jendle 

[![Build Status](https://secure.travis-ci.org/toyama0919/jendle.png?branch=master)](http://travis-ci.org/toyama0919/jendle)
[![Gem Version](https://badge.fury.io/rb/jendle.svg)](http://badge.fury.io/rb/jendle)

Jenkins as code management tool.

## Setting profile

```yaml
default:
  server_ip: localhost

staging:
  server_ip: staging-server
  username: admin
  password: XXXXXXXXXXXXX

production:
  server_ip: production-server
  username: admin
  password: XXXXXXXXXXXXX
```

## export

```
$ jendle export -p staging
```

* export Jobfile, Viewfile, Pluginfile

## apply

```
$ jendle apply -p production
```

## apply unit

```
$ jendle apply_plugins -p production
$ jendle apply_jobs -p production
$ jendle apply_views -p production
```

## install

Add this line to your application's Gemfile:

    gem 'jendle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jendle

## Synopsis

    $ jendle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Information

* [Homepage](https://github.com/toyama0919/jendle)
* [Issues](https://github.com/toyama0919/jendle/issues)
* [Documentation](http://rubydoc.info/gems/jendle/frames)
* [Email](mailto:toyama0919@gmail.com)

## Copyright

Copyright (c) 2017 

See [LICENSE.txt](../LICENSE.txt) for details.
