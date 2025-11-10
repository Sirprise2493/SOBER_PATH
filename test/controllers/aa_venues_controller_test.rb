require "test_helper"

class AaVenuesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get aa_venues_create_url
    assert_response :success
  end
end
