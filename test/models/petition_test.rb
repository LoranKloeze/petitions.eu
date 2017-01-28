require 'test_helper'

class PetitionTest < ActiveSupport::TestCase
  include Concerns::StripWhitespace
  include Concerns::TruncateString

  setup do
    @petition = petitions(:one)
  end

  test 'strip leading and trailing whitespace' do
    [:name, :description, :initiators, :statement, :request].each do |field|
      assert_strip_whitespace(@petition, field)
    end
  end

  test 'link texts should be truncated' do
    [:link1_text, :link2_text, :link3_text].each do |field|
      assert_truncate_string(@petition, field)
    end
  end
end
