# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ContentsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :content, through: :team, through_association: :contents

    # GET /api/v1/teams/:team_id/contents
    def index
    end

    # GET /api/v1/contents/:id
    def show
    end

    # POST /api/v1/teams/:team_id/contents
    def create
      if @content.save
        render :show, status: :created, location: [:api, :v1, @content]
      else
        render json: @content.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/contents/:id
    def update
      if @content.update(content_params)
        render :show
      else
        render json: @content.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/contents/:id
    def destroy
      @content.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def content_params
        strong_params = params.require(:content).permit(
          *permitted_fields,
          :title,
          :description,
          :url,
          :active,
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
  class Api::V1::ContentsController
  end
end
