require 'telegram_bot'
require 'uri'
require 'net/http'
require 'json'

token = '1795392938:AAEXABnlkXMD6L2prz2EqifzMpl1vwWf_hU'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /chart/i
      reply.text = "You can find the chart here: https://dex.guru/token/0x4b4c5d87fa1afe3365fa1ee9cb6c38cc6fab8fef-bsc"
    when /price/i
	  uri = URI('https://api.dex.guru/v1/tokens/0x4B4c5D87fa1aFE3365Fa1ee9cb6c38cC6FAB8fEf-bsc')
	  res = Net::HTTP.get_response(uri)
		parsed = JSON.parse(res.body)
	  # reply.text = parsed['data']['price'][0..5]
	  reply.text = parsed["priceUSD"].round(5)
	when /contract/i
		reply.text = "0x4b4c5d87fa1afe3365fa1ee9cb6c38cc6fab8fef"
	when /bsclink/i
		reply.text = "https://bscscan.com/token/0x4b4c5d87fa1afe3365fa1ee9cb6c38cc6fab8fef"
	when /site/i
		reply.text = "weedswap.io"
	when /help/i
		reply.text = "Here are the commands:
						chart = reply with chart link
						price = reply with price of the WeedSwap token
						contract = reply with the contract address
						bsclink = reply with the link to the bscscan
						site = reply with the site link
						help = shows this message"
    else
      break
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end