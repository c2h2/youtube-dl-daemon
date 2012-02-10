require 'rubygems'
require 'sinatra'
require 'mongoid'
require './models.rb'

set :server, %w[thin mongrel webrick]

def wrap html
  "<pre>#{html}</pre>"
end

def valid_url? url
  (url.to_s =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix) == 0
end

get '/' do
  total = Vid.all.length
  str = "Number of total items: #{total}"
  str += "<ul>\n"
  list = Vid.all.map{|v| "  <li>#{v.url}|#{v.dl_ed}|#{v.created_at}</li>\n"} * "" 
  str += list
  str += "</ul>\n<p />\n"
  str += '<form name="input" action="new" method="get">
Youtube URL: <input type="text" name="url" />
<input type="submit" value="Submit" />
</form>'
  str
end

get '/new' do
  str =""
  url = params[:url]
  if !valid_url? url
    str = wrap "INVALID URL"
  elsif Vid.where(url:url).length > 0
    #already exists
    str = wrap "Duplicated."
  else
    v=Vid.new
    v.url = url
    v.save
    str = "SAVED. <a href='/'>Home</a>"
  end
  str
end

get '/flush' do
  Vid.destroy_all
  wrap "ALL DELETED"

end