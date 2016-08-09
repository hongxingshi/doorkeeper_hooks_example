require 'rails_helper'

describe Doorkeeper::TokensController do
  it 'hits the dummy logger in action :create' do
    expect(controller).to receive(:dummy_logger)
    post :create
  end

  it 'hits the dummy logger in action :revoke' do
    expect(controller).to receive(:dummy_logger)
    post :revoke
  end
end
