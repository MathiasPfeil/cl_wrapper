# CL_Wrapper

CL\_Wrapper is a light web scraper for the Craigslist Cars & Trucks section. When supplied with a Craigslist post via URL,
CL_Wrapper will turn the post into an easy to use Ruby object.

## Getting Started

In a Rails project:

Copy the cl_wrapper.rb and cl_wrapper directory into your lib directory, then include it in one of your models like so:

```ruby
class Listing < ApplicationRecord
  require_dependency('cl_wrapper')
end
```

You can now use CL_Wrapper to get information from a Craigslist posting.

```ruby
# Url you would like to scrape.
url = 'https://sanantonio.craigslist.org/cto/d/some-car-ad'

@cl = CL_Wrapper.listing(url, {use_category: 'cto'}) do

  # Set your own error messages (not required).
  set_error(:wrong_website, 'Sorry, at the moment we only allow posts from Craigslist.')
  set_error(:wrong_category, 'The Craigslist add you posted was not in the cars & trucks category.')
  
  # Require that some elements from the Craigslist post be present.
  require_element(:image)
end

@cl.post_id  # => '6739513085'
@cl.title    # => '02 Mazda Miata'
@cl.desc     # => 'Lorem Ipsum...'
@cl.price    # => 5000
@cl.address  # => 'Braun at Tezel'
@cl.location # => 'San Antonio'
@cl.date     # => '6 days ago'
@cl.category # => 'cars & trucks - by owner'
@cl.section  # => 'for sale'
@cl.attr     # => [Transmission: manual, Miles: 50,000]
@cl.image    # => 'https://images.craigslist.org/the_image_url_600x450.jpg'
@cl.solicitable # => false
```

### Prerequisites

CL_Wrapper requires that you have the ```gem 'nokogiri'``` installed.




## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details