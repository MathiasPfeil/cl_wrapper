module CL_Wrapper
  class Page
    attr_reader :init_errors
    
    def initialize(url, opt)
      @opt         = opt
      @error_msgs  = {}
      @init_errors = []
      
      if is_valid_url?(url) && use_specific_category(url)
        @document  = Nokogiri::HTML(open(url).read)
      else
        throw_error(:wrong_website, 'URL is not a Craigslist page.')
      end
    end
    
    private
    
    # Make sure posts can only come from defined Craigslist categories.
    def use_specific_category(url)
      if @opt[:use_category].present?
        if url.include?("/#{@opt[:use_category]}/d/")
          return true
        else
          throw_error(:wrong_category, 'Craigslist post is not from accepted category.')
        end
      else
        return true
      end
    end
    
    # If there is an error, add it to error_msgs hash
    def throw_error(type, txt)
      @init_errors << :error
      @init_errors << (@opt[type].present? ? @opt[type] : txt)
    end
    
    # Make sure supplied url points to the Craigslist website.
    def is_valid_url?(url)
      split_url = URI.parse(url).host.split('.')
      split_url[-1] == 'org' && split_url[-2] == 'craigslist'
    end
  end
end