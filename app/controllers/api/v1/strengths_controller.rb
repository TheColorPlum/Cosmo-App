# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::StrengthsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :strength, through: :feature, through_association: :strengths

    # GET /api/v1/features/:feature_id/strengths
    def index
    end

    # GET /api/v1/strengths/:id
    def show
    end

    # POST /api/v1/features/:feature_id/strengths
    def create
      if @strength.save
        render :show, status: :created, location: [:api, :v1, @strength]
      else
        render json: @strength.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/strengths/:id
    def update
      if @strength.update(strength_params)
        render :show
      else
        render json: @strength.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/strengths/:id
    def destroy
      @strength.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def strength_params
        strong_params = params.require(:strength).permit(
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
  class Api::V1::StrengthsController
  end
end
