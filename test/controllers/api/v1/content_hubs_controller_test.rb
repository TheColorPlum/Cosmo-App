require "controllers/api/v1/test"

class Api::V1::ContentHubsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @content_hub = build(:content_hub, team: @team)
      @other_content_hubs = create_list(:content_hub, 3)

      @another_content_hub = create(:content_hub, team: @team)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @content_hub.save
      @another_content_hub.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(content_hub_data)
      # Fetch the content_hub in question and prepare to compare it's attributes.
      content_hub = ContentHub.find(content_hub_data["id"])

      assert_equal_or_nil content_hub_data['title'], content_hub.title
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal content_hub_data["team_id"], content_hub.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/content_hubs", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      content_hub_ids_returned = response.parsed_body.map { |content_hub| content_hub["id"] }
      assert_includes(content_hub_ids_returned, @content_hub.id)

      # But not returning other people's resources.
      assert_not_includes(content_hub_ids_returned, @other_content_hubs[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/content_hubs/#{@content_hub.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/content_hubs/#{@content_hub.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      content_hub_data = JSON.parse(build(:content_hub, team: nil).to_api_json.to_json)
      content_hub_data.except!("id", "team_id", "created_at", "updated_at")
      params[:content_hub] = content_hub_data

      post "/api/v1/teams/#{@team.id}/content_hubs", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/content_hubs",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/content_hubs/#{@content_hub.id}", params: {
        access_token: access_token,
        content_hub: {
          title: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @content_hub.reload
      assert_equal @content_hub.title, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/content_hubs/#{@content_hub.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("ContentHub.count", -1) do
        delete "/api/v1/content_hubs/#{@content_hub.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/content_hubs/#{@another_content_hub.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
