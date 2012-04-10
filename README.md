# KayakFares

Library to return fares from the [Kayak Search Gateway](http://www.kayak.com/labs/gateway/doc/air.vtl) using [Mechanize](http://mechanize.rubyforge.org/).

## Usage

Add to Gemfile:

    gem 'kayak_fares'

Search for fares:

    params = {:from => "SBN", :to => "VRN", :depart => "5/15/2012", :return => "5/20/2012"}
    search = KayakFares.new(params)

    search.results[0].price
    => $1240

    search.results[0].airline
    => United

    search.results[0].leg0_departure_time
    => 7:44p

    search.results[0].leg0_arrival_time
    => 10:35p

    search.results[0].leg0_duration
    => 20h 51m

    search.results[0].leg1_departure_time
    => 6:55a

    search.results[0].leg1_arrival_time
    => 11:26p

    search.results[0].leg1_duration
    => 22h 31m

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine, but bump version in a commit by itself so we can ignore when we pull)
* Send us a pull request. Bonus points for topic branches.