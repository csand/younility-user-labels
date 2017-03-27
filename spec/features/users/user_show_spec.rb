include Warden::Test::Helpers
Warden.test_mode!

# Feature: User profile page
#   As a user
#   I want to visit my user profile page
#   So I can see my personal account data
feature 'User profile page', :devise do

  after(:each) do
    Warden.test_reset!
  end

  # Scenario: User sees own profile
  #   Given I am signed in
  #   When I visit the user profile page
  #   Then I see my own email address
  scenario 'user sees own profile' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit user_path(user)
    expect(page).to have_content 'User'
    expect(page).to have_content user.email
  end

  # Scenario: User cannot see another user's profile
  #   Given I am signed in
  #   When I visit another user's profile
  #   Then I see an 'access denied' message
  scenario "user cannot see another user's profile" do
    me = FactoryGirl.create(:user)
    other = FactoryGirl.create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)
    Capybara.current_session.driver.header 'Referer', root_path
    visit user_path(other)
    expect(page).to have_content 'Access denied.'
  end

  # Scenario: Labels are displayed on user profile
  #   Given I am signed include
  #   When I visit another user's profile
  #   Then I see that user's labels
  scenario "labels are displayed on user's profile" do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    user.labels << label
    user.save
    login_as(user, scope: :user)
    visit user_path(user)
    expect(page).to have_content(label.name)
  end

  # Scenario: Labels are displayed on user profile
  #   Given I am signed in
  #   When I visit my profile page
  #   Then I see my labels
  scenario "labels are displayed on user's profile" do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    user.labels << label
    login_as(user, scope: :user)
    visit user_path(user)
    expect(page).to have_content(label.name)
  end

  # Scenario: Add label to user from user profile
  #   Given I am signed in
  #   When I visit my profile page
  #   Then I see that user's labels
  scenario "adding labels on user's profile" do
    user = FactoryGirl.create(:user, :admin)
    login_as(user, scope: :user)
    visit user_path(user)
    fill_in 'Name', with: 'Fancy'
    fill_in 'Color', with: '#00ffff'
    click_button 'Add Label'
    expect(page).to have_content('Fancy')
    expect(page).to have_content('Label Fancy added to user')
  end

  # Scenario: Add existing label to user
  #   Given I am signed in
  #   When I visit my profile page
  #   And I try to add a label that already exists
  #   Then I see a message about that label already existing
  scenario "add existing label on user's profile" do
    user = FactoryGirl.create(:user, :admin)
    label = FactoryGirl.create(:label)
    user.labels << label
    login_as(user, scope: :user)
    visit user_path(user)
    fill_in 'Name', with: 'Fancy'
    fill_in 'Color', with: '#00ffff'
    click_button 'Add Label'
    expect(page).to have_content(/label already exists/i)
  end
end
