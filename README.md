Yet Another Crawler
==========

A web crawler, which given a URL, outputs a sitemap with the assets links for each page within the same URL domain.

* Ruby 2.2.3+
* Rails 4.2.6+
* Nokogiri

Testing
-
```
bundle exec rspec / bundle exec guard
```

Important notes so far
-

1. Any page belonging to an external domain won't be crawled, so that means every reference pointing to `https://example-external.com/page` or `//example.cdn.com`.

Author
-
@leandronsp
