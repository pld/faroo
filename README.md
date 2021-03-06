[![Build Status](https://api.travis-ci.org/pld/faroo.svg?branch=master)](https://travis-ci.org/pld/faroo)

# faroo

Gem providing a API for the Faroo search engine.
https://rubygems.org/gems/faroo

## Notes

To improve performance results are retrieved in chunks of 10 simultaneously
through threads.  Threads are timed out after MAX_TTL seconds (currently 2).
It is best effort, users will see an inconsistent number of retrieved results
and tests will fail if requests are slow.

## Installation

* install the gem

```bash
gem install faroo
```

## Example

```ruby
Faroo.new(token).web('nanotubes')
=> [ #<FarooResult:...>, ... ]
```

## Contributing

Running the tests:

```bash
TOKEN='any-string-should-work' bundle exec rspec
```


## Ownership

Copyright (c) 2012, Peter Lubell-Doughtie. Licensed under the 3-clause BSD License, which is also known as the "Modified BSD License". Full text of the license is below. This license is GPL compatible (http://www.gnu.org/licenses/license-list.html#ModifiedBSD).

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL (COPYRIGHT HOLDER) BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

