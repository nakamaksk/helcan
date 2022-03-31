
class LineController < ApplicationController
  require 'line/bot'

  before_action :authenticate_user!, except: :callback

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    unless params[:token] == ENV["API_TOKEN"]
      head :unauthorized && return
    end

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request && return
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: reply_message(event.message['text'], event['source']['userId'])
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    end

    head :ok

  end

  def reply_message(message, line_user_id)
    person = Person.find_by_line_user_id(line_user_id)
    return '' unless person

    case message
    when '身長'
      person.height
    when '体重'
      person.weight
    when 'BMI'
      person.bmi
    else
      <<~"MSG".chomp
        身長：#{person.height}cm
        体重：#{person.weight}kg
        BMI：#{format("%.2f", person.bmi)}
        体脂肪：#{format("%.2f", person.body_fat)}%
        肥満度：#{person.fat_level}
      MSG
    end
  end
end
