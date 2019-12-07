class CreateExistingPollingDistricts < ActiveRecord::Migration[5.2]
  def up
    PollingStation.all.each do |ps|
      ActiveRecord::Base.transaction do
        # Need to grab `polling_district` in this way as now that
        # `polling_district_id` and `polling_district` relation have been added
        # this would be given by `ps.polling_district` instead.
        district_reference = ps.attributes['polling_district']

        if district_reference.nil?
          STDERR.puts "PollingStation #{ps.id} has no polling_district set - deleting..."
          ps.delete
          next
        end

        ps.polling_district = PollingDistrict.find_or_create_by!(
          ward_id: ps.ward_id,
          reference: district_reference
        )
        STDERR.puts "PollingStation #{ps.reference} associated with #{ps.polling_district.reference} (#{ps.polling_district.id})"
        ps.save!
      end
    end
  end
end
