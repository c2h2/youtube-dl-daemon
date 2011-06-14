#!/usr/bin/env ruby

DL = '/youtube-dl'
DLER = '/usr/bin/youtube-dl'

STATUS_NEW      = "new"
STATUS_WORKING  = "processing"
STATUS_FINISHED = "finished"
require 'sinatra'



#queue is a generic que, can be extended by memcache, internal or active record.
class Job
  def initialize
    setup_que  
  end

  #def setup_que
  #end

  #def enqueue item
  #end
  

end

#internalQueue
class IntJob < Job
  def setup_que
    @que = []
  end
    
  def add_a_job job
    job = {:item => item, :status=> STATUS_NEW, :created_at => Time.now, :started_at=>nil, :finished_at=>nil }
    @que << job
    @que.index job #return the index of the queue
  end

  def get_a_job #returns a job or nil
    @que.each_with_index do |job, index|
      if job[:status] == STATUS_NEW
        que_update index, {:status => STATUS_WORKING, :started_at => Time.now}
        return obj
      end
    end
    nil
  end

  def finish_a_job id
    job = @que[id]
    job[:status]=STATUS_FINISHED
  end

  private

  def que_update id, params
    params.each {|k,v| @que[id][k] = v}
    save
  end

  def save

  end

end


class UDLER

  def initialize
    
  end






  def add_sinatra_stuff
    get '/list' do
      'hello world!'
    end

    post '/add' do
      params[:url] + " hello"
    end

  end

end




#u=UDLER.new
#u.add_sinatra_stuff
