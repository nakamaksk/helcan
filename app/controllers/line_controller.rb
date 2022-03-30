require 'line/bot'

class LineController < ApplicationController
  def test
    client = Line::Bot::Client.new { |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    message = {
      type: 'text',
      text: 'Hello, World!'
    }
    client.broadcast(message)

    render json: message
  end
end


