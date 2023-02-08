# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::FeaturesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :feature, through: :product, through_association: :features

    # GET /api/v1/products/:product_id/features
    def index
    end

    # GET /api/v1/features/:id
    def show
    end

    # POST /api/v1/products/:product_id/features
    def create
      if @feature.save
        render :show, status: :created, location: [:api, :v1, @feature]
      else
        render json: @feature.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/features/:id
    def update
      if @feature.update(feature_params)
        render :show
      else
        render json: @feature.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/features/:id
    def destroy
      @feature.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def feature_params
        strong_params = params.require(:feature).permit(
          *permitted_fields,
          :name,
          :description,
          :url,
          :cost,
          :price,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::FeaturesController
  end
end
