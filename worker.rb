require File.expand_path(File.join(File.dirname(__FILE__), "models.rb"))
DIR = "~/youtube"
`mkdir -p #{DIR}`
SLEEPTIME = 30

def log str
  puts Time.now.to_s + "|" + str
end

log "Started."
loop do
  vids = Vid.where(dl_ed: false)
  vids.each do |v|
    log "DLing #{v.url}"
    v.dl_to DIR
    v.dl_ed = true
    v.save
  end
  log "Loop finished, sleep #{SLEEPTIME} sec."
  sleep SLEEPTIME
end
