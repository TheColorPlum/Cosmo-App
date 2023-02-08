require "controllers/api/v1/test"

class Api::V1::ProductsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @product = build(:product, team: @team)
      @other_products = create_list(:product, 3)

      @another_product = create(:product, team: @team)

      # 🚅 super scaffolding will insert file-related logic above this line.
      @product.save
      @another_product.save
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(product_data)
      # Fetch the product in question and prepare to compare it's attributes.
      product = Product.find(product_data["id"])

      assert_equal_or_nil product_data['name'], product.name
      assert_equal_or_nil product_data['description'], product.description
      assert_equal_or_nil product_data['url'], product.url
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal product_data["team_id"], product.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/products", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      product_ids_returned = response.parsed_body.map { |product| product["id"] }
      assert_includes(product_ids_returned, @product.id)

      # But not returning other people's resources.
      assert_not_includes(product_ids_returned, @other_products[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/products/#{@product.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/products/#{@product.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      product_data = JSON.parse(build(:product, team: nil).to_api_json.to_json)
      product_data.except!("id", "team_id", "created_at", "updated_at")
      params[:product] = product_data

      post "/api/v1/teams/#{@team.id}/products", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/products",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/products/#{@product.id}", params: {
        access_token: access_token,
        product: {
          name: 'Alternative String Value',
          description: 'Alternative String Value',
          url: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @product.reload
      assert_equal @product.name, 'Alternative String Value'
      assert_equal @product.description, 'Alternative String Value'
      assert_equal @product.url, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/products/#{@product.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Product.count", -1) do
        delete "/api/v1/products/#{@product.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/products/#{@another_product.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
