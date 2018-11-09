module CL_Wrapper
  class Listing < Page
    # Instance methods which can be used to retrieve data from the supplied 
    # Craigslist post.
    attr_reader :post_id, :title, :desc, :price, :address, :location,
    :date, :category, :section, :attr, :image, :solicitable
    
    def initialize(url, opt)
      super
      if @init_errors.empty?
        is_listing?
        @post_id     = element_text('.postinginfos > .postinginfo', 'post id:')
        @title       = element_text('#titletextonly')
        @price       = element_text('.price')
        @date        = element_text('.date.timeago')
        @location    = element_text('.crumb.area',     '>')
        @category    = element_text('.crumb.category', '>')
        @section     = element_text('.crumb.section',  '>')

        @desc        = @document.css('#postingbody > text()').text.strip
        @address     = has_address(element_text('.mapaddress'))

        @solicitable = is_solicitable?
        @attr        = listing_attr
        @image       = listing_image
      end
    end
    
    # Check if price of listing is less than the supplied amount.
    def price_less_than?(ad_price)
      @price.delete('$ ,').to_i <= ad_price
    end
    
    private
    
    # Get text inside of a selected element on the page.
    def element_text(selector, remove = '')
      begin
        @document.css(selector).first.text.delete(remove).strip
      rescue
        nil
      end
    end
    
    # Make sure url supplied is to a Craigslist ad and not an index page.
    def is_listing?
      throw_error(:page_error, "The link you gave is not a currently active Craigslist post.") if @document.css('.postinginfo').empty?
    end
    
    # Check if ad creator has listed address
    def has_address(address)
      address.present? && address.include?('google map') ? nil : address
    end
    
    # Get attributes listed in ad. E.g. "Transmission: manual, Miles: 50,000"
    def listing_attr
      begin
        @document.css('.attrgroup')[1].text.gsub("\n",'').split("\s\s").reject(&:empty?)
      rescue
        nil
      end
    end
    
    # Get link to first image that displays when opening ad.
    def listing_image
      if @document.css('.slide.first').css('img').present?
        main_img = open(@document.css('.slide.first').css('img').attr('src'))
      elsif @opt[:required_elements].present? && @opt[:required_elements].include?(:image)
        throw_error(:missing_element, "Your ad could not be saved because it is missing an image.")
      else
        nil
      end
    end
    
    # Check if ad creator can be contacted with offers unrelated to their post.
    def is_solicitable?
      !@document.css('.notices > li').text.include?('do NOT contact me with unsolicited services or offers')
    end
    
  end
end