require 'pry'
require 'smarter_csv'

new_clubs = SmarterCSV.process('app/main/lib/fieldGuide.csv', :file_encoding => 'windows-1251:utf-8')

Volt.skip_permissions do
  new_clubs.each do |club|
    find_club = Volt.current_app.store.clubs.where(name: club[:name]).first.sync
    unless find_club
      data = Volt.current_app.store.clubs.buffer
      data._name = club[:name]
      data._description = club[:description]
      data._more_info = club[:more_info]
      data.save!.then do |d|
        unless club[:competencies] == ''
          comps = club[:competencies].split(', ')
          comps.each do |comp|
            new_comp = Volt.current_app.store.competencies.buffer
            new_comp._name = comp
            new_comp.club_id = d.id
            new_comp.save!
          end
        end
      end.fail do |err|
        puts "Unable to save because #{err}"
      end
    end
  end
end
