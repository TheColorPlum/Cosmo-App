# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::WeaknessesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :weakness, through: :feature, through_association: :weaknesses

    # GET /api/v1/features/:feature_id/weaknesses
    def index
    end

    # GET /api/v1/weaknesses/:id
    def show
    end

    # POST /api/v1/features/:feature_id/weaknesses
    def create
      if @weakness.save
        render :show, status: :created, location: [:api, :v1, @weakness]
      else
        render json: @weakness.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/weaknesses/:id
    def update
      if @weakness.update(weakness_params)
        render :show
      else
        render json: @weakness.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/weaknesses/:id
    def destroy
      @weakness.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def weakness_params
        strong_params = params.require(:weakness).permit(
          *permitted_fields,
          :name,
          :description,
          :category,
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
  class Api::V1::WeaknessesController
  end
end
