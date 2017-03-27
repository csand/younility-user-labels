include Warden::Test::Helpers
Warden.test_mode!

# Feature: Label index page
#   As a user
#   I want to see a list of labels
#   So I can see all of the labels that exist
feature 'Label index page', :devise do
  after(:each) do
    Warden.test_reset!
  end

  # Scenario: Label listed on index page
  #   Given I am signed in
  #   When I visit the label index page
  #   Then I see existing labels
  scenario 'label present on index' do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    login_as(user, scope: :user)
    visit labels_path
    expect(page).to have_content(label.name)
    # TODO: check for label color
  end
end
