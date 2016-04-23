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

# def find_or_create_practice_by_address(data)
#   practice = Volt.current_app.store.practices.where(address_1: data[:address_1], city: data[:city], state: data[:state], zip_code: data[:zip_code]).limit(1).first.sync
#   unless practice
#     practice = Volt.current_app.store.practices.buffer({name: "#{data[:first_name]} #{data[:last_name]} #{data[:practicetype]}", address_1: data[:address_1], city: data[:city], state: data[:state], zip_code: data[:zip_code], address_type: 'State Board'})
#     practice.save!.sync
#     data[:owner] = true
#   end
#   practice.id
# end
#
# def find_or_create_dentists(data)
#   data[:type_of_practice] = PRACTICE_TYPES["#{data[:type_of_practice]}"]
#   dentist = Volt.current_app.store.dentists.where({'$and' => [{license_number: "#{data[:license_number]}"}, {state: 'OK'}]}).first.sync
#   if dentist
#     # Mandatory updates
#     dentist.license_status = 'Active'
#     dentist.disciplinary_action = data[:disciplinary_action]
#     dentist.license_expiration_date = data[:expiration]
#
#     # Update the other fields if they are blank
#     data.each_pair do |k,v|
#       if dentist.respond_to?(k)
#         if dentist.send(k) == nil
#           dentist.send("#{k}=", v)
#         end
#       end
#     end
#   else
#     data[:practice_id] = find_or_create_practice_by_address(data)
#     dentist = Volt.current_app.store.dentists.buffer(data)
#     dentist.save!.fail do |e|
#       Volt.logger.error "Unable to save dentist with license number #{dentist.license_number}. Error was #{e}"
#     end
#   end
# end
#
#
# new_dentists = SmarterCSV.process('lib/OK_Dentists.csv', :key_mapping => {:first => :first_name, :last => :last_name, :middle => :middle_name,:"lic_#" => :license_number, :issued => :license_issue_date, :correspondence_address => :address_1, :disciplinary_actions => :disciplinary_action, :type => :type_of_practice, :zip => :zip_code})
#
# Volt.skip_permissions do
#   new_dentists.each do |dentist|
#     find_or_create_dentists(dentist)
#   end
# end
