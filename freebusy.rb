# freebusy.rb
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'sinatra'

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
<<<<<<< HEAD
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
=======
  #credentials = authorizer.get_credentials(user_id)
  credentials = 4/nnBofWjEuAAYsUl2KM3FZ3Yk1UxrekTyneO-zcfdFWM
  #if credentials.nil?
  #  url = authorizer.get_authorization_url(
  #    base_url: OOB_URI)
  #  puts "Open the following URL in the browser and enter the " +
  #       "resulting code after authorization"
  #  puts url
    #code = gets
    #credentials = authorizer.get_and_store_credentials_from_code(
    #  user_id: user_id, code: code, base_url: OOB_URI)
  #end
  #credentials
>>>>>>> parent of 20730f4... debug
end


# Initialize the API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
#service.authorization = authorize

# Create bookable resources
boardroom = 'sparkbureau.co_dgruu710vf146n88afsvj4pm84@group.calendar.google.com'
meeting_room_1 = 'sparkbureau.co_a383sh2shilibm53kh8beun8oo@group.calendar.google.com'
meeting_room_2 = 'sparkbureau.co_fqagctfc9u62mkk0oqdbsj43jk@group.calendar.google.com'

#Time Format = '2016-05-13T09:00:00+10:00'
#http://localhost:9393/freebusy/2016-05-19T07:00:00+10:00/2016-05-19T08:00:00+10:00

get '/freebusy/:start_time/:end_time' do

  start_time = params['start_time']
  end_time = params['end_time']

#Fetch any events between start and end times
  response = service.list_events(boardroom,
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
