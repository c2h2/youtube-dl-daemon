class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url, :type => String
  field :html, :type => String
  field :to_expand, :type=> Boolean, :default => false
  field :to_dl, :type => Boolean, :default => false
  field :processed, :type => Boolean, :default => false
  has_and_belongs_to_many :videos

  def get_page

  end

  def parse_page #to get other page and other videos
    self_uri = URI.parse(self.url)
    noko = Nokogiri::HTML(self.html)
    links = noko.css('a')
    urls = links.map{|link| (self_uri.merge URI.parse(link[:href])).to_s }
    urls.each {|url|
      p = Page.new   
      p.url = url
      p.save
      if Video.is_youtube? url
        v = Video.new
        v.url = url
        v.save_new_video
      end
    }
  end

  def dl_page
    hash = {"User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3 (FM Scene 4.6.1)"} 
    begin 
      open(self.url, hash) do |f|
        self.html     = f.read
        self.save
      end
    rescue 
      
    end
  end

  def save_page doc
    self.html = doc
  end

  def self.exists? url
    Page.where(url: url).count > 0
  end 

end
