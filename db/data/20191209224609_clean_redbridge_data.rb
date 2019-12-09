class CleanRedbridgeData < ActiveRecord::Migration[5.2]
  def up
    redbridge = Council.find_by(code: 'E09000026')

    # Skip migration in this case, have obviously not imported Redbridge data
    # in this environment.
    return unless redbridge

    # Fix clumsily written PollingStation references.
    redbridge.polling_stations.each do |ps|
      ps.reference = ps.reference.gsub(' -', '-').gsub('- ', '-')
      ps.save!
    end

    # Fix up badly parsed PollingStation and PollingDistrict. There are more
    # like this but this is the only one in the data we're using for demoing.
    bad_polling_station = redbridge.polling_stations.find_by!(
      reference: 'BR2/5-15')
    correct_district = redbridge.polling_districts.find_by!(reference: 'BR2')

    # Just assign this PollingDistrict to have some junk Ward/Council, and then
    # replace PollingStation's district below. Would just delete but this saves
    # having to deal with all the cascade issues in prod when doing this right
    # now.
    bad_polling_station.polling_district.ward = Ward.create!(
      name: 'junk',
      code: 'junk',
      council: Council.create!(
        name: 'junk',
        code: 'junk',
        transient: true
      )
    )
    bad_polling_station.polling_district.save!

    bad_polling_station.polling_district = correct_district
    bad_polling_station.reference = 'BR2-15'
    bad_polling_station.save!
  end
end
