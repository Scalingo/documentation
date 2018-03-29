---
modified_at:	2018-03-29 10:45:00
title:	'Ruby - Version 2.5.1, 2.4.4, 2.3.7, 2.2.10 support added'
github: 'https://github.com/Scalingo/ruby-buildpack'
---

Ruby versions 2.2.10, 2.3.7, 2.4.4, and 2.5.1 are security releases made due to these vulnerabilities:
* CVE-2017-17742: Response splitting vulnerability in WEBrick
* CVE-2018-6914: Directory traversal with Dir.mktmpdir and Tempfile
* CVE-2018-8777: webrick large request updates
* CVE-2018-8779: Unix domain socket and a path containing a null character
* CVE-2018-8778: controlled buffer under-read in pack_unpack_internal()
* CVE-2018-8780: NUL-character treatment with Dir
* RubyGem 2.7.6 (see https://www.ruby-lang.org/en/news/2018/02/17/multiple-vulnerabilities-in-rubygems/)
