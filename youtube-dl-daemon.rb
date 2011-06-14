#!/usr/bin/env ruby
DIR = '/youtube/'
DL = '/youtube-dl'
DLER = '/usr/bin/youtube-dl'

STATUS_NEW      = "new"
STATUS_WORKING  = "processing"
STATUS_FINISHED = "finished"

PROXY = "export http_proxy=http://192.168.0.205:1077"

require 'sinatra'

#queue is a generic que, can be extended by memcache, internal or active record.
class Job
  def initialize
    setup_que  
  end
end

#internalQueue
class IntJob < Job
  def setup_que
    @que = []
  end
    
  def add_a_job job
    job = {:id=> nil, :job => job, :status=> STATUS_NEW, :created_at => Time.now, :started_at=>nil, :finished_at=>nil }
    @que << job
    id = @que.index job 
    @que[id][:id] = id
  end
  
  def get id
    @que[id]
  end

  def get_a_job #returns a job or nil
    @que.each_with_index do |job, index|
      if job[:status] == STATUS_NEW
        que_update index, {:status => STATUS_WORKING, :started_at => Time.now}
        return job
      end
    end
    nil
  end

  def finish_a_job id
    job = @que[id]
    que_update id, {:status => STATUS_FINISHED}
  end

  def to_html
    str="<pre>"
    str+="######### START OF YOUTUBE DIR #{DIR} #############\n"
    str+=`ls -ashl #{DIR}`
    str+="\n######### Job Queue #############\n"
    str+="id      job    status   created_at        started_at    finished_at  "
    @que.each do |job|
      str = str + "#{job[:id]} #{job[:job]} #{job[:status]} #{job[:created_at]} #{job[:started_at]}  #{job[:finished_at]}"
    end
    str+="\n\n######### Add a new job #############\n"

    str=str+"</pre>"
  end


  private

  def que_update id, params
    params.each {|k,v| @que[id][k] = v}
    save_2_file
  end

  def save_2_file

  end

  def load_from_file
   
  end

end


class UDLER
  attr_accessor :q

  def initialize
    @q = IntJob.new
    @threads=[]  
  end

  def do_work
    #might need a threadpool here
    while true
      job=@q.get_a_job
      unless job.nil?
        @threads<<Thread.new{ dl job }
      end
      sleep 1
    end
  end

  def dl job
    `#{PROXY}; cd #{DIR}; /usr/bin/youtube-dl -t #{job[:job]}`
    @q.finish_a_job job[:id]
  end

  def url? url
    ! (url =~ URI::regexp).nil?
  end
end


u=UDLER.new
Thread.new{
  u.do_work
}

get '/' do
  msg = "<h1>Welcome to youtube-dl-daemon by c2h2.</h1>\n"
  msg = msg + u.q.to_html
  msg = msg + '<FORM ACTION="add" METHOD=POST>Please add an youtube url:<input type="text" name="url"><br><input type="submit" value="add"></FORM><META HTTP-EQUIV="REFRESH" CONTENT="60">'
end

post '/add' do
  url = params[:url] 
  if u.url? url
    msg = "URL = #{url} added okay!"
    u.q.add_a_job url
  else 
    msg = "URL = #{url} added failed!"
  end
  msg = msg + '<p><a href="/">Home</a></p>'
  msg
end
