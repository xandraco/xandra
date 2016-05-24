# xandrabooking.rb
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'sinatra'
#require "sinatra/json"

require 'fileutils'
require 'date'


OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# Create bookable resources
boardroom = 'sparkbureau.co_dgruu710vf146n88afsvj4pm84@group.calendar.google.com'
meeting_room_1 = 'sparkbureau.co_a383sh2shilibm53kh8beun8oo@group.calendar.google.com'
meeting_room_2 = 'sparkbureau.co_fqagctfc9u62mkk0oqdbsj43jk@group.calendar.google.com'

#Time Format = '2016-05-13T09:00:00+10:00'
#http://localhost:4567/freebusy/boardroom/june/3/10:00/11:00

#Parse JSON request body
#before do
#  request.body.rewind
#  @request_payload = JSON.parse request.body.read
#end

get '/freebusy/:room_type/:month/:date/:start/:finish' do

# retrieve input values from url parameters
  room_type = params['room_type']
  month = params['month']
  date = params['date']
  start = params['start']
  finish = params['finish']

# convert month name input to month number string
  if month.downcase == "january"
    month_num = "01"
  elsif month.downcase == "february"
    month_num = "02"
  elsif month.downcase == "march"
    month_num = "03"
  elsif month.downcase == "april"
    month_num = "04"
  elsif month.downcase == "may"
    month_num = "05"
  elsif month.downcase == "june"
    month_num = "06"
  elsif month.downcase == "july"
    month_num = "07"
  elsif month.downcase == "august"
    month_num = "08"
  elsif month.downcase == "september"
    month_num = "09"
  elsif month.downcase == "october"
    month_num = "10"
  elsif month.downcase == "november"
    month_num = "11"
  elsif month.downcase == "december"
    month_num = "12"
  end

# construct datetime format from parameter values
  start_time = "2016-" + month_num + "-" + date + "T" + start + ":00+10:00"
  end_time = "2016-" + month_num + "-" + date + "T" + finish + ":00+10:00"

# set meeting room from parameter value
if room_type.downcase == "boardroom"
  meeting_room = boardroom
elsif room_type.downcase == "meeting_room_1"
  meeting_room = meeting_room_1
elsif room_type.downcase == "meeting_room_2"
  meeting_room = meeting_room_2
end

#Fetch any events between start and end times
  response = service.list_events(meeting_room,
            time_min: start_time,
            time_max: end_time
    )

# Respond with "Free" or "Busy" for testing only
  if response.items.empty?
      available = "Free"
    else
      available = "Busy"
     available
    end
end

# use confirmed booking details parameters to do calendar quickadd
get '/quickadd/:room_type/:month/:date/:start/:finish' do
  # retrieve input values from url parameters
    room_type = params['room_type']
    month = params['month']
    date = params['date']
    start = params['start']
    finish = params['finish']

    # set meeting room from parameter value
    if room_type.downcase == "boardroom"
      meeting_room = boardroom
    elsif room_type.downcase == "meeting_room_1"
      meeting_room = meeting_room_1
    elsif room_type.downcase == "meeting_room_2"
      meeting_room = meeting_room_2
    end

    booking = "Booked via xandra on " + month + " " + date + " " + start + " - " + finish

  # Quick Add Event
   result = service.quick_add_event(
      meeting_room,
      booking)
   booking
end
