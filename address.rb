require 'HTTParty'

class Address
  @@base_uri = "http://blockchain.info/address"

  attr_accessor :address, :final_balance, :tx_count, 
                :total_sent, :total_received, :txs

  def initialize(address)
    @address = address
    request_uri = @@base_uri + "/#{@address}?format=json"
    @response = HTTParty.get(request_uri)
    if @response.success?
      parse_response(@response)
    else
      raise @response.response
    end
  end

  def parse_response(response)
    @address = response['address']
    @tx_count = response['n_tx']
    @final_balance = response['final_balance']
    @total_received = response['total_received']
    @total_sent = response['total_sent']
    @txs = response['txs']
  end

  def recipients_since(time)
    recipients = []
    txs_since(time).each do |tx|
      tx['out'].each do |out|
        recipients << out['addr'] if out['addr'] != @address
      end
    end
  end

  def txs_since(time)
    @txs.select do |tx|
      tx['time'] > time
    end
  end

end