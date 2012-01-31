require 'curb'
require 'progress_bar'

desc "Syncronize blue-pages tree"

namespace :esp_auth do
  task :sync => :environment do
    remotes = JSON.parse(Curl::Easy.http_get("#{Settings['blue_pages.url']}/categories/2.json?sync=true").body_str)
    bar = ProgressBar.new(remotes.count)
    remotes.each do | remote |
      (Context.find_by_id(remote['id']) || Context.new).tap do | context |
        context.update_attributes! remote
      end
      bar.increment!
    end
  end
end
