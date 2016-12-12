class Spinach::Features::User < Spinach::FeatureSteps

  step 'I enter login page' do
    @user = FactoryGirl.create(:user)
    visit root_path
  end

  step 'I fill email with wrong password' do
    fill_in "email", with: @user.email
    fill_in "password", with: "WRONG"
    click_button "Prihlásit"
  end

  step 'I should be informed that login went wrong' do
    page.must_have_content("Zadané heslo je nesprávne")
  end

  step 'I fill correct email and password double' do
    fill_in "email", with: @user.email
    fill_in "password", with: "password"
    click_button "Prihlásit"
  end

  step 'I should be logged in' do
    page.must_have_content("Identifikácia klienta")
  end
end
