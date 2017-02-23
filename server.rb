require 'sinatra'
require 'haml'
require 'json'

get '/' do
  content_type 'text/plain'
  File.read(File.expand_path(File.dirname(__FILE__)) + '/README.md')
end

get '/:ledger_name' do
  data_file = File.read(File.expand_path(File.dirname(__FILE__)) + "/data/#{params[:ledger_name]}.json")
  @ledger_data = Array.new
  @ledger_ids = Set.new
  
  # Removes ledgers with duplicate activity_ids
  # Formats the ledger objects to display user-friendly information
  JSON.parse(data_file).each do |ledger|
  	if not @ledger_ids.include? ledger['activity_id']
  		formatted_ledger = getFormattedLedger(ledger)
  		@ledger_data.push(formatted_ledger)
  		@ledger_ids.add(formatted_ledger['activity_id'])
  	end
  end

  # Sorts ledgers in descending order by Date, and ascending order by Balance
  # This is necessary to display ledgers in a logical transaction history
  @ledger_data = 
  	@ledger_data.sort do |a, b| 
  		[b['date'], a['balance']] <=> [a['date'], b['balance']]
  	end
  
  raise 'No data' unless @ledger_data
  haml :ledger
end

# Formats each ledger by providing extra fields to be used for displaying information
# Keeps original data properties intact, but stores extra fields for user-friendly display formats
def getFormattedLedger(ledger)
	ledger['formatted_type'] = ledger['type'].split(' ').map {|word| word.capitalize}.join(' ')
	ledger['formatted_description'] = getFormattedDescription(ledger)
	ledger['formatted_date'] = getFormattedDate(ledger['date'])
	return ledger
end

# Converts ISO 8601 timestamp to user friendly date format: dd/mm/yyyy
# Couldn't find external library function that worked for this use case but I'm sure one exists
def getFormattedDate(date)
	before_t = date.split('T')[0]
	y_m_d = before_t.split('-')
	formatted_str = y_m_d[2] + '/' + y_m_d[1] + '/' + y_m_d[0]
	return formatted_str
end

# Base method that gets detailed description for each account transaction
def getFormattedDescription(ledger)
   if ledger == nil
   	  return 'Unknown description'
   elsif ledger['amount'] > 0
   	  return getDescriptionText(ledger, 'source')	
   else
   	  return getDescriptionText(ledger, 'destination')
   end
end

# Helper method for determining description text based on transaction type and information available
def getDescriptionText(ledger, type)
   # Determines the right description whether funds traveled to source acct or external destination acct
   base = ledger[type]
   if type == 'source'
   	  if base == nil
   	      return ledger['formatted_type'].concat(' from Unknown Source')
   	  else
   	  	  str = ledger['formatted_type'].concat(' from ')
   	  end
   else
   	  if base == nil
   	  	 return ledger['formatted_type'].concat(' to Unknown Acct')
   	  else
   	  	 str = ledger['formatted_type'].concat(' to ')
      end
   end

   # Determines if type or description fields are available to add to the transaction description
   description = base['description']
   type = base['type'].split(' ').map {|word| word.capitalize}.join(' ')

   if not description == nil
   	  str.concat(description)
   elsif not type == nil
      str.concat(type).concat(' Source')
   else
      str.concat('Unknown')
   end
   
   return str
end

# Makes Haml available to client
def render_file(filename)
  contents = File.read(filename)
  Haml::Engine.new(contents).render
end