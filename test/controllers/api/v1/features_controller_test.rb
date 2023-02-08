require "controllers/api/v1/test"

class Api::V1::FeaturesControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @product = create(:product, team: @team)
@feature = build(:feature, product: @product)
      @other_features = create_list(:feature, 3)

      @another_feature = create(:feature, product: @product)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @feature.save
      @another_feature.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(feature_data)
      # Fetch the feature in question and prepare to compare it's attributes.
      feature = Feature.find(feature_data["id"])

      assert_equal_or_nil feature_data['name'], feature.name
      assert_equal_or_nil feature_data['description'], feature.description
      assert_equal_or_nil feature_data['url'], feature.url
      assert_equal_or_nil feature_data['cost'], feature.cost
      assert_equal_or_nil feature_data['price'], feature.price
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal feature_data["product_id"], feature.product_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/products/#{@product.id}/features", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      feature_ids_returned = response.parsed_body.map { |feature| feature["id"] }
      assert_includes(feature_ids_returned, @feature.id)

      # But not returning other people's resources.
      assert_not_includes(feature_ids_returned, @other_features[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/features/#{@feature.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/features/#{@feature.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      feature_data = JSON.parse(build(:feature, product: nil).to_api_json.to_json)
      feature_data.except!("id", "product_id", "created_at", "updated_at")
      params[:feature] = feature_data

      post "/api/v1/products/#{@product.id}/features", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/products/#{@product.id}/features",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/features/#{@feature.id}", params: {
        access_token: access_token,
        feature: {
          name: 'Alternative String Value',
          description: 'Alternative String Value',
          url: 'Alternative String Value',
          cost: 'Alternative String Value',
          price: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @feature.reload
      assert_equal @feature.name, 'Alternative String Value'
      assert_equal @feature.description, 'Alternative String Value'
      assert_equal @feature.url, 'Alternative String Value'
      assert_equal @feature.cost, 'Alternative String Value'
      assert_equal @feature.price, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/features/#{@feature.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Feature.count", -1) do
        delete "/api/v1/features/#{@feature.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/features/#{@another_feature.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
