# Metriknit

Merge (“knit” together) the results of various code analysis (metrics) tools.

[Github source code repository](https://github.com/grantneufeld/metriknit)

## Requirements

* ruby >= 1.9
* bundler
* git

## Installation

In your project `gemfile`, add:

```ruby
group :development do
  gem 'metriknit', git: 'https://github.com/grantneufeld/metriknit.git', require: false
end
```

Then, from the root directory for your project:

    bundle install

### Gem Setup

Metriknit uses the following rubygems to perform various code analysis.

Metriknit supports:
* [brakeman](http://brakemanscanner.org/): Rails security analysis.
* [cane](https://github.com/square/cane): Code style and complexity.
* [churn](https://github.com/danmayer/churn): Code change frequency.
* [flog](https://github.com/seattlerb/flog): Code complexity.
* [rails_best_practices](https://github.com/railsbp/rails_best_practices): Best practices for Rails code.
* [reek](https://github.com/troessner/reek): Code smells.
* [roodi](https://github.com/martinjandrews/roodi): Code smells.
* [tailor](https://github.com/turboladen/tailor): Code style.

Future support might hopefully include:
* [flay](https://github.com/seattlerb/flay): Code duplication.
* rspec profile: Per-test profiling for speed.
* simplecov: Test coverage.

## Usage

From the root directory of your ruby project:

    bundle exec metriknit

## Contributors

* [Grant Neufeld](https://github.com/grantneufeld)

## Legal

Copyright ©2013 Grant Neufeld.

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
