require 'curb'
require 'progress_bar'

desc "Syncronize blue-pages tree"

namespace :esp_permissions do
  task :sync => :environment do
    foreigns = JSON.parse(Curl::Easy.http_get("#{Settings['blue-pages.url']}/categories/2.json?sync=true").body_str)
    bar = ProgressBar.new(foreigns.count)
    foreigns.each do | foreign |
      Context.find_or_initialize_by_remote_id(foreign[:id]).tap do | context |
        context.update_attributes! foreign
        p context
      end
      bar.increment!
    end
  end
end
