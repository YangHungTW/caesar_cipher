require "ruby/openai"
require "dotenv/load"


puts "Enter a encrypted message: "
encrypted_message = gets.chomp

client = OpenAI::Client.new(
  access_token: ENV["OPENAI_TOKEN"]
)

(1...26).each do |i|
  descrypted_arr = []
  encrypted_message.split("").map do |letter|
    base = 0
    if letter.ord >= 65 && letter.ord <= 90
      base = 65
    elsif letter.ord >= 97 && letter.ord <= 122
      base = 97
    end

    descrypted_letter = letter
    if !base.zero?
      descrypted_letter = ((((letter.ord - base) - i) % 26) + base).chr
    end

    descrypted_arr << descrypted_letter
  end
  puts "i: #{i}"
  descrypted_msg = descrypted_arr.join

  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        "role": "user",
        "content": "If you can understand \"#{descrypted_msg}\", please response 'true' else 'false'."
      }],
      temperature: 0,
    }
  )

  response_text = response.dig("choices", 0, "message", "content").downcase.strip

  puts "The message is \"#{descrypted_msg}\""
  if response_text == "true"
    puts "Decryption shift is #{i}"
    break
  end

end
