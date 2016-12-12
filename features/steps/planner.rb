class Spinach::Features::Planner < Spinach::FeatureSteps
  include Common::LoginFlow

  step 'I\'m on identification page' do
    @user = FactoryGirl.create(:user)
    login_as(@user)
  end

  step 'I enter existing company IČO and click Create' do
    InterfaceCache.create(ic: '12345678')
    fill_in 'client', with: '12345678'
    click_button 'Vyhladať klienta'
  end

  step 'I should see page with company details' do
    page.must_have_content 'C.E.I. consulting a.s.'
  end

  step 'some loans already exist' do
    FactoryGirl.create(:client, name: "test loan", ic: '12345678')
    FactoryGirl.create(:interface_cache, ic: '12345678')
    @user = FactoryGirl.create(:user)
    login_as(@user)
  end

  step 'I enter planner' do
    visit root_path
  end

  step 'I should see all of them' do
    page.must_have_content 'C.E.I. consulting a.s.'
  end
end
