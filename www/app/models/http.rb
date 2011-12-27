class Http
  def initialize hash
    @settings = {:remain_times => 3, :dl_ed => false, :ua=>""}

  end


  def dl url, hash
    hash = @settings.merge hash
    if remain_times <= 0
      hash[:code] = 1999
      hash[:dl_ed] = false
      Util.log "Error in DL #{url} really failed after #{remain_times} times"
      return
    end
    hash = {"User-Agent" => Conf.get_ua}
    Util.log "DL #{url}"
    sw=Stopwatch.new
    begin
      Timeout::timeout(Conf.time(:network)) do
        open(url, hash) do |f|
          @doc     = f.read
          self.charset = f.charset
          self.mime    = f.content_type
          self.code    = f.status[0].to_i
          f.base_uri
          f.meta
          begin
            self.expires_at = Time.parse(f.meta["expires"])
          rescue => e
            #no expires found
          end

          begin
            self.etag = f.meta["etag"]
          rescue => e
            #no etag found
          end

          unless f.last_modified.nil?
            self.lm_at = f.last_modified
          end
        end
        self.dl_ed=true
        self.response_time =  (sw.end * 1000).floor
      end
    rescue => e
      dl(remain_times - 1)
      Util.log "Error in dl|#{url}|RETRYING#{remain_times - 1}|#{e}"
    end



end
