require "rails_helper"

RSpec.feature "Templates::UpgradeCustomisations", type: :feature do

  let(:funder) { create(:org, :funder, name: "The funder org") }

  let(:org) { create(:org, :organisation, name: "The User's org") }

  let(:user) { create(:user, org: org) }

  let(:funder_template) do
    create(:template, :default, :publicly_visible, :published,
           org: funder, title: "Funder Template")
  end

  let(:customized_template) { funder_template.customize!(org) }

  before do
    create_list(:phase, 1, template: funder_template).each do |phase|
      create_list(:section, 2, phase: phase).each do |section|
        create_list(:question, 2, section: section)
      end
    end
    user.perms << create(:perm, :modify_templates)
    user.perms << create(:perm, :add_organisations)
    user.perms << create(:perm, :change_org_affiliation)
    user.perms << create(:perm, :add_organisations)
  end

  scenario "Admin upgrades customizations from funder Template", :js do
    sign_in user
    visit org_admin_templates_path

    # Customise a Template that belongs to another funder Org
    click_link("Customisable Templates")

    within "#template_#{funder_template.id}" do
      click_button "Actions"
      click_link "Customise"
    end

    click_link "View all templates"

    # Publish our customisation
    within "#template_#{funder_template.id}" do
      click_button "Actions"
      click_link "Publish"
    end

    new_funder_template = Template.last

    # Move to the other funder Org's Templates
    fill_in(:superadmin_user_org_name, with: funder.name)
    choose_suggestion(funder.name)
    click_button("Change affiliation")

    # Edit the original Template
    click_link "#{funder.name} Templates"

    within "#template_#{funder_template.id}" do
      click_button "Actions"
      click_link "Edit"
    end
    click_link(funder_template.phases.first.title)

    click_link "Add a new section"
    within('#new_section_new_section') do
      fill_in :new_section_section_title, with: "New section title"
      tinymce_fill_in :new_section_section_description, with: "New section title"
      click_button("Save")
    end
    new_funder_template = Template.last

    expect(new_funder_template.sections).to have(3).items
    click_link "View all templates"

    within "#template_#{new_funder_template.id}" do
      click_button "Actions"
      click_link "Publish changes"
    end

    # Go back to the original Org...

    fill_in(:superadmin_user_org_name, with: org.name)
    choose_suggestion(org.name)
    click_button("Change affiliation")

    click_link "Customisable Templates"

    within "#template_#{new_funder_template.id}" do
      click_button "Actions"
      click_link "Transfer customisation"
    end

    new_customized_template = Template.last

    expect(page).to have_text("Customisations are published")
    expect(new_funder_template.reload.sections).to have(3).items
    expect(new_customized_template.reload.sections).to have(3).items
    expect(funder_template.sections).to have(2).items
    expect(customized_template.sections).to have(2).items
  end

end
