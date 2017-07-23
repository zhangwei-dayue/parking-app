require 'rails_helper'

feature "parking", :type => :feature do
  scenario "guest parking" do
    visit "/"
    save_and_open_page
    expect(page).to have_content("一般费率")

    click_button "开始计费"

    click_button "结束计费"

    expect(page).to have_content("¥2.00")
  end
end
