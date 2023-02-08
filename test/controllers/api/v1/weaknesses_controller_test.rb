require "controllers/api/v1/test"

class Api::V1::WeaknessesControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @feature = create(:feature, team: @team)
@weakness = build(:weakness, feature: @feature)
      @other_weaknesses = create_list(:weakness, 3)

      @another_weakness = create(:weakness, feature: @feature)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @weakness.save
      @another_weakness.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(weakness_data)
      # Fetch the weakness in question and prepare to compare it's attributes.
      weakness = Weakness.find(weakness_data["id"])

      assert_equal_or_nil weakness_data['name'], weakness.name
      assert_equal_or_nil weakness_data['description'], weakness.description
      assert_equal_or_nil weakness_data['category'], weakness.category
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal weakness_data["feature_id"], weakness.feature_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/features/#{@feature.id}/weaknesses", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      weakness_ids_returned = response.parsed_body.map { |weakness| weakness["id"] }
      assert_includes(weakness_ids_returned, @weakness.id)

      # But not returning other people's resources.
      assert_not_includes(weakness_ids_returned, @other_weaknesses[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/weaknesses/#{@weakness.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/weaknesses/#{@weakness.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      weakness_data = JSON.parse(build(:weakness, feature: nil).to_api_json.to_json)
      weakness_data.except!("id", "feature_id", "created_at", "updated_at")
      params[:weakness] = weakness_data

      post "/api/v1/features/#{@feature.id}/weaknesses", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/features/#{@feature.id}/weaknesses",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/weaknesses/#{@weakness.id}", params: {
        access_token: access_token,
        weakness: {
          name: 'Alternative String Value',
          description: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @weakness.reload
      assert_equal @weakness.name, 'Alternative String Value'
      assert_equal @weakness.description, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/weaknesses/#{@weakness.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Weakness.count", -1) do
        delete "/api/v1/weaknesses/#{@weakness.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/weaknesses/#{@another_weakness.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
