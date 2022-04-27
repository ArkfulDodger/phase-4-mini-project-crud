class SpicesController < ApplicationController
  # assign @spice variable based on params[:id]
  before_action :find_spice, only: %i[update destroy]

  # error handling for non-existent records and failed validations
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  # GET /spices
  def index
    spices = Spice.all
    render json: spices
  end

  # POST /spices
  def create
    spice = Spice.create!(spice_params)
    render json: spice, status: :created
  end

  # PATCH /spices/:id
  def update
    @spice.update!(spice_params)
    render json: @spice, status: :accepted
  end

  # DELETE /spices/:id
  def destroy
    @spice.destroy

    head :no_content
    # render json: @spice, status: :ok
  end

  private

  # set instance variable for show/update/destroy
  def find_spice
    @spice = Spice.find(params[:id])
  end

  # permissible params to be used by create/update
  def spice_params
    params.permit(:id, :title, :image, :description, :notes, :rating)
  end

  # response when requested spice not in database
  def render_not_found_response
    render json: { error: 'Not found' }, status: :not_found
  end

  # response when spice failed validations to be created/updated
  def render_invalid_response(error_obj)
    render json: {
             errors: error_obj.record.errors.full_messages
           },
           status: :unprocessable_entity
  end
end
