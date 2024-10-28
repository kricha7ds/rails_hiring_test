class PollingLocationsController < ApplicationController
  before_action :set_riding
  before_action :set_polling_location, only: %i[ show edit update destroy ]

  # GET /polling_location or /polling_location.json
  def index
    @polling_locations = @riding.polling_locations
  end

  # GET /polling_location/1 or /polling_location/1.json
  def show
    @polling_location
  end

  # GET /polling_location/new
  def new
    @polling_location = @riding.polling_locations.build
    @available_polls = @riding.polls
                              .where(polling_location_id: nil)
                              .sort_by { |poll| poll.number.to_i }
  end

  # GET /polling_location/1/edit
  def edit
    @available_polls = @riding.polls
                              .where('polling_location_id IS NULL OR polling_location_id = ?', @polling_location.id)
                              .sort_by { |poll| poll.number.to_i }
  end

  # POST /polling_location or /polling_location.json
  def create
    @polling_location = @riding.polling_locations.build(polling_location_params)

    respond_to do |format|
      if @polling_location.save
        format.html { redirect_to riding_url(@riding), notice: "Polling location was successfully created." }
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append("polling_locations",
                                  partial: "polling_locations/polling_location",
                                  locals: { polling_location: @polling_location, riding: @riding }
            ),
            turbo_stream.update("new_polling_location", partial: "polling_locations/add", locals: { riding: @riding })
          ]
        }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polling_location/1 or /polling_location/1.json
  def update
    respond_to do |format|
      if @polling_location.update(polling_location_params)
        format.html { redirect_to riding_url(@riding), notice: "Polling location was successfully updated." }
        format.json { render :show, status: :ok, location: @polling_location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @polling_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polling_location/1 or /polling_location/1.json
  def destroy
    @polling_location.destroy

    respond_to do |format|
      format.html { redirect_to riding_url(@riding), notice: "Polling location was successfully deleted." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@polling_location) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_riding
      @riding = Riding.find(params[:riding_id])
    end

    def set_polling_location
      @polling_location = @riding.polling_locations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def polling_location_params
      params.require(:polling_location).permit(:title, :address, :city, :postal_code, poll_ids: [])
    end
end
