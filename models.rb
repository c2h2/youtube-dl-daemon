require 'mongoid'

### mongo conn ###
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("youtube")
end


class Vid
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url,      type: String
  field :dl_ed,    type: Boolean, default: false
  field :fn,       type: String
  field :artist,   type: String
  field :title,    type: String
  field :video_id, type: String
  field :file_size, type: Float
  field :tags

  index :url, unique: true
  index :video_id

  def dl_to dir
    `cd #{dir}; youtube-dl -t '#{self.url}'`
  end

  def exist? url
    
  end
  
end
