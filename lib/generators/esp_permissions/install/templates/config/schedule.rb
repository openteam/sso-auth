every 1.day, :at => '4:00 am' do
    rake 'esp_permissions:sync'
end
