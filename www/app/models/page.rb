class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url, :type => String
  field :html, :type => String
  field :processed, :type => Boolean
  has_and_belongs_to_many :videos

  def get_page

  end

  def parse_page #to get other page and other videos

  end

  def save_page doc
    self.html = doc
  end

  def self.exists? url
    Page.where(url: url).count > 0
  end 

  

end
