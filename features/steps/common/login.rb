module Common
  module LoginFlow
    include Spinach::DSL

    step 'I log in' do
      @user = FactoryGirl.create(:user)
      login_as(@user)
    end

    private

    def login_as(user)
      visit new_session_path
      fill_in "email", with: user.email
      fill_in "password", with: user.password
      click_button "Prihlásit"
    end

  end
end