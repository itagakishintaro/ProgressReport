# http://ruby-rails.hatenadiary.com/entry/20150108/1420675366#api-jbuilder-rspec-implement-respond_to
module Api
  class TagsController < ApplicationController
    def index
      @tags = Report.select("tag").uniq
      render json: @tags
    end
  end
end