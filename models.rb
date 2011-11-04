require 'mongoid'

### mongo conn ###
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("youtube")
end


class Vid
  include Mongoid::Document
  include Mongoid::Timestamps
  field :url,   type: String
  field :dl_ed, type: Boolean, default: false
  field :fn,    type: String

  index :url, unique: true

  def dl_to dir
    `cd #{dir}; youtube-dl -t '#{self.url}'`
  end
end
