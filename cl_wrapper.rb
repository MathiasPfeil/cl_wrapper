require 'open-uri'
require 'nokogiri'

require_relative 'cl_wrapper/page'
require_relative 'cl_wrapper/listing'

# CL_Wrapper is a light web scraper for Craigslist. When supplied with a Craigslist post via URL,
# CL_Wrapper will turn the post into an easy to use Ruby object.
module CL_Wrapper
  class << self
    
    def listing(url, opt = {}, &callback)
      @@opts = opt
      instance_eval(&callback)
      Listing.new(url, @@opts)
    end
    
    def set_error(key, value)
      @@opts[key] = value
    end
    
    def require_element(*elements)
      @@opts[:required_elements] = elements
    end
    
  end
end