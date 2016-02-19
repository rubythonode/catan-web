class WatchesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :issue
  load_and_authorize_resource :watch, through: :issue, shallow: true

  def create
    @watch.user = current_user
    @watch.save

    respond_to do |format|
      format.js
    end
  end

  def cancel
    @watch = @issue.watches.find_by user: current_user
    @watch.destroy

    respond_to do |format|
      format.js
    end
  end
end
