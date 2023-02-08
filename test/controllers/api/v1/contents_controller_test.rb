require "controllers/api/v1/test"

class Api::V1::ContentsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @content = build(:content, team: @team)
      @other_contents = create_list(:content, 3)

      @another_content = create(:content, team: @team)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @content.save
      @another_content.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(content_data)
      # Fetch the content in question and prepare to compare it's attributes.
      content = Content.find(content_data["id"])

      assert_equal_or_nil content_data['title'], content.title
      assert_equal_or_nil content_data['description'], content.description
      assert_equal_or_nil content_data['url'], content.url
      assert_equal_or_nil content_data['active'], content.active
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal content_data["team_id"], content.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/contents", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      content_ids_returned = response.parsed_body.map { |content| content["id"] }
      assert_includes(content_ids_returned, @content.id)

      # But not returning other people's resources.
      assert_not_includes(content_ids_returned, @other_contents[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/contents/#{@content.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/contents/#{@content.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      content_data = JSON.parse(build(:content, team: nil).to_api_json.to_json)
      content_data.except!("id", "team_id", "created_at", "updated_at")
      params[:content] = content_data

      post "/api/v1/teams/#{@team.id}/contents", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/contents",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/contents/#{@content.id}", params: {
        access_token: access_token,
        content: {
          title: 'Alternative String Value',
          description: 'Alternative String Value',
          url: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @content.reload
      assert_equal @content.title, 'Alternative String Value'
      assert_equal @content.description, 'Alternative String Value'
      assert_equal @content.url, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/contents/#{@content.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Content.count", -1) do
        delete "/api/v1/contents/#{@content.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/contents/#{@another_content.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
