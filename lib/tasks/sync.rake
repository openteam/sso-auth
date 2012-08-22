require 'esp-commons'
require 'progress_bar'
require 'timecop'

desc "Syncronize blue-pages tree"

namespace :esp_auth do
  task :sync => :environment do
    remotes = JSON.parse(Requester.new("#{Settings['blue-pages.url']}/categories/2.json?sync=true").response_body)
    bar = ProgressBar.new(remotes.count + (Context.pluck('id') - remotes.map{|r| r['id']}).count)

    Context.record_timestamps = false
    updated_at = Time.zone.now

    remotes.each do |remote|
      Timecop.freeze(updated_at) do
        (Context.find_or_initialize_by_id(remote['id'])).tap do |context|
          context.created_at ||= updated_at
          context.updated_at = updated_at
          context.update_attributes! remote
        end
      end
      bar.increment!
    end

    Context.where('updated_at <> ?', updated_at).each do |stale_context|
      stale_context.destroy
      bar.increment!
    end
  end
end
