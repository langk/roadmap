# frozen_string_literal: true

require 'shoulda/matchers'

AVAILABLE_TEST_LOCALES = LocaleSet.new(["en-GB"]) #%w[ en-GB en fr de ])

RSpec.configure do |config|

  config.before(:suite) do
    # This is required for the Faker gem. See this issue here:
    # https://github.com/stympy/faker/issues/266
    I18n.available_locales        = AVAILABLE_TEST_LOCALES.for(:i18n)
    FastGettext.default_available_locales = AVAILABLE_TEST_LOCALES.for(:fast_gettext)
    I18n.default_locale           = AVAILABLE_TEST_LOCALES.for(:i18n).first
    FastGettext.default_locale    = AVAILABLE_TEST_LOCALES.for(:fast_gettext).first
  end

  config.before(:each, type: :feature) do
    I18n.config.enforce_available_locales = true
    I18n.config.locale = LocaleFormatter.new(I18n.default_locale, format: :i18n).to_s
    FastGettext.locale = LocaleFormatter.new(FastGettext.default_locale, format: :fast_gettext).to_s
  end

end
