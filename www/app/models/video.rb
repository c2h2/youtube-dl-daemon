class Video
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ytid, :type => String
  field :url, :type => String
  field :title, :type => String
  field :uploader, :type => String
  field :desc, :type => String
  field :fn, :type => String
  field :size, :type => Integer
  field :status, :type => Integer
  field :to_dl, :type => Boolean, :default => true
  field :processing, :type => Boolean
  field :error
  has_and_belongs_to_many :pages

  def self.is_youtube? url
    #http://stackoverflow.com/questions/8306963/regular-expression-youtube-url
    (url =~ /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=[^?]*v=\w+)(?:[^\s?]+)?$/) == 0
  end

  def get_ytid
    if self.ytid.nil? or self.ytid.length == 0 
      return self.url[/(?<=[?&]v=)[^&$]+/]
    else
      return self.ytid
    end
  end

  def get_url_hash
    hash = {}
    get_part = self.url.split("?").last
    param_part = get_part.split("&").last
    param_part.each do |param|
      kv = param.split("=")
      hash[kv[0].strip] = kv[1].strip
    end
    hash
  end
  
  def save_new_video
    ytid = self.get_ytid
    if Video.where( ytid: ytid).count == 0
      if Video.is_youtube?(self.url)
        if self.ytid.nil? or self.ytid.length ==0
          self.ytid = self.get_ytid
        end
        self.save
        ret = true
      else
        self.error = "NOT saved, NOT a youtube video url or ytid."
        ret =  false
      end
    else
      self.error = "NOT saved, duplicated Video."
      ret = false
    end
    ret 
  end
    
  def get_url
    if self.url.nil? or self.url.length == 0
      return "http://www.youtube.com/watch?v=#{self.ytid}"
    else
      return self.url
    end
  end

end
