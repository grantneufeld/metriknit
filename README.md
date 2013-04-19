# Metriknit

Merge (“knit” together) the results of various code analysis (metrics) tools.

[Source code repository](https://github.com/grantneufeld/metriknit)

## Requirements

* ruby >= 1.9
* git

## Installation

In your gemfile, add:

```ruby
gem 'metriknit', git: 'https://github.com/grantneufeld/metriknit.git', require: false
```

### Gem Setup

Metriknit will run based on the code analysis rubygems you have installed.

Metriknit supports:
* [brakeman](http://brakemanscanner.org/): Rails security analysis.
* [cane](https://github.com/square/cane): Code style and complexity.
* [churn](https://github.com/danmayer/churn): Code change frequency.
* [flog](https://github.com/seattlerb/flog): Code complexity.
* [rails_best_practices](https://github.com/railsbp/rails_best_practices): Best practices for Rails code.
* [reek](https://github.com/troessner/reek): Code smells.
* [roodi](https://github.com/martinjandrews/roodi): Code smells.
* [tailor](https://github.com/turboladen/tailor): Code style.

Future support planned for:
* [flay](https://github.com/seattlerb/flay): Code duplication.
* simplecov: Test coverage.

## Usage

From the root directory of your ruby project:

    metriknit

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
