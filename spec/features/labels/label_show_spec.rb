
include Warden::Test::Helpers
Warden.test_mode!

# Feature: Label index page
#   As a user
#   I want to examine a label
#   So I can see the users with that label
feature 'Label show page', :devise do
  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User listed on show page
  #   Given I am signed in
  #   When I visit a label's show page
  #   Then I see users with that label
  scenario 'labelled users are present' do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    user.labels << label
    login_as(user, scope: :user)
    visit label_path(label)
    expect(page).to have_content(user.email)
  end

  # Scenario: Delete label from show page
  #   Given I am signed in
  #   When I visit a label's show page
  #   Then I can delete that label
  scenario 'delete label' do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    login_as(user, scope: :user)
    visit label_path(label)
    click_link 'Delete this label'
    expect(page).to have_content('Label deleted')
  end
end
