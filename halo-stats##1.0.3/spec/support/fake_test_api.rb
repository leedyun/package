require 'sinatra/base'

class FakeTestApi < Sinatra::Base
  REQUEST_TYPES = [:get]
  #
  # /stats endpoints
  #
  get('/stats/h5/players/faketag/matches') {json_response 200, 'matches.json'}
  get('/stats/h5/arena/matches/1') {json_response 200, 'matches.json'}
  get('/stats/h5/campaign/matches/1') {json_response 200, 'matches.json'}
  get('/stats/h5/custom/matches/1') {json_response 200, 'matches.json'}
  get('/stats/h5/warzone/matches/1') {json_response 200, 'matches.json'}
  get('/stats/h5/arena/matches/1') {json_response 200, 'matches.json'}
  get('/stats/h5/servicerecords/arena') {json_response 200, 'matches.json'}
  get('/stats/h5/servicerecords/custom') {json_response 200, 'matches.json'}
  get('/stats/h5/servicerecords/campaign') {json_response 200, 'matches.json'}
  get('/stats/h5/servicerecords/warzone') {json_response 200, 'matches.json'}

  #
  # /profile endpoints
  #
  get('/profile/h5/profiles/faketag/emblem') {json_response 302, 'posts.json'}
  get('/profile/h5/profiles/faketag/spartan') {json_response 302, 'posts.json'}

  #
  # /metadata endpoints
  #
  get('/metadata/h5/metadata/campaign-missions') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/commendations') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/csr-designations') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/enemies') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/flexible-stats') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/game-base-variants') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/game-variants/1') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/impulses') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/map-variants/1') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/maps') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/medals') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/playlists') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/requisition-packs/1') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/requisitions/1') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/seasons') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/skulls') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/spartan-ranks') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/team-colors') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/vehicles') {json_response 200, 'posts.json'}
  get('/metadata/h5/metadata/weapons') {json_response 200, 'posts.json'}

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read if file_name
  end
end