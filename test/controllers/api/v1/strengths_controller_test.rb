require "controllers/api/v1/test"

class Api::V1::StrengthsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @feature = create(:feature, team: @team)
@strength = build(:strength, feature: @feature)
      @other_strengths = create_list(:strength, 3)

      @another_strength = create(:strength, feature: @feature)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @strength.save
      @another_strength.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(strength_data)
      # Fetch the strength in question and prepare to compare it's attributes.
      strength = Strength.find(strength_data["id"])

      assert_equal_or_nil strength_data['name'], strength.name
      assert_equal_or_nil strength_data['description'], strength.description
      assert_equal_or_nil strength_data['category'], strength.category
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal strength_data["feature_id"], strength.feature_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/features/#{@feature.id}/strengths", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      strength_ids_returned = response.parsed_body.map { |strength| strength["id"] }
      assert_includes(strength_ids_returned, @strength.id)

      # But not returning other people's resources.
      assert_not_includes(strength_ids_returned, @other_strengths[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/strengths/#{@strength.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/strengths/#{@strength.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      strength_data = JSON.parse(build(:strength, feature: nil).to_api_json.to_json)
      strength_data.except!("id", "feature_id", "created_at", "updated_at")
      params[:strength] = strength_data

      post "/api/v1/features/#{@feature.id}/strengths", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/features/#{@feature.id}/strengths",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/strengths/#{@strength.id}", params: {
        access_token: access_token,
        strength: {
          name: 'Alternative String Value',
          description: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @strength.reload
      assert_equal @strength.name, 'Alternative String Value'
      assert_equal @strength.description, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/strengths/#{@strength.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Strength.count", -1) do
        delete "/api/v1/strengths/#{@strength.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/strengths/#{@another_strength.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
