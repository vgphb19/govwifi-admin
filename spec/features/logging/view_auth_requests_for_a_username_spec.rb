require 'features/support/sign_up_helpers'

describe "View authentication requests for a username" do
  context "with results" do
    let(:username) { "AAAAAA" }
    let(:organisation) { create(:organisation) }
    let(:admin_user) { create(:user, :confirmed, organisation_id: organisation.id) }
    let(:location) { create(:location, organisation_id: organisation.id) }

    before do
      Session.create!(
        start: "2018-10-01 18:18:09 +0000",
        username: username,
        mac: '',
        ap: '',
        siteIP: '1.1.1.1',
        success: true,
        building_identifier: ''
      )

      Session.create!(
        start: "2018-10-01 18:18:09 +0000",
        username: username,
        mac: '',
        ap: '',
        siteIP: '1.1.1.1',
        success: false,
        building_identifier: ''
      )

      Session.create!(
        start: "2018-10-01 18:18:09 +0000",
        username: username,
        mac: '',
        ap: '',
        siteIP: '2.2.2.2',
        success: false,
        building_identifier: ''
      )

      organisation = create(:organisation)
      location_two = create(:location, organisation: organisation)

      create(:ip, location_id: location.id, address: "1.1.1.1")
      create(:ip, location: location_two, address: "2.2.2.2")

      sign_in_user admin_user
      visit search_logs_path
      fill_in "username", with: username
      click_on "Submit"
    end

    context "when username is correct" do
      let(:username) { "AAAAAA" }

      it "displays the authentication requests" do
        expect(page).to have_content("Displaying logs for #{username}")
        expect(page).to have_content("successful")
        expect(page).to have_content("failed")
      end

      it "displays the logs of the ip the organisation does not own" do
        expect(page).to have_content("1.1.1.1")
      end

      it "does not display the logs of the ip the organisation does not own" do
        expect(page).to_not have_content("2.2.2.2")
      end
    end

    context "when username is too short" do
      let(:username) { "1" }

      it "displays the search page with an error" do
        expect(page).to have_content("There is a problem")
        expect(page).to have_content("Username must be 6 characters in length")
        expect(page).to have_content("Find authentication requests for a username")
      end
    end
  end

  context 'without results' do
    let(:user) { create(:user, :confirmed, :with_organisation) }
    let(:username) { 'random' }

    before do
      sign_in_user user
      visit search_logs_path
      fill_in 'username', with: username
      click_on 'Submit'
    end

    it 'displays the no results message' do
      expect(page).to have_content("No results found for that username, please try again")
    end
  end
end