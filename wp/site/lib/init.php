<?php

    putenv("TZ=America/Los_Angeles");
#    define('DB_DSN', 'mysql://paperwalking:w4lks@localhost/paperwalking');
    define('DB_DSN', 'pgsql://sensory:sensory@localhost/paperwalking');
    define('TMP_DIR', dirname(realpath(__FILE__)).'/../tmp');
    
    define('API_PASSWORD', 'hoopla');
    define('COOKIE_SIGNATURE', '*** you choose this ***');

    // Comma-delimited list of ws-compose.py host:ports
    define('WSCOMPOSE_HOSTPORTS', '');

    // Yahoo GeoPlanet application ID
    define('GEOPLANET_APPID', '*** http://developer.yahoo.com/geo/geoplanet/ ***');

    // Cloudmade developer key
    define('CLOUDMADE_KEY', '*** http://developers.cloudmade.com/ ***');

    // Flickr application key
    define('FLICKR_KEY', '*** http://www.flickr.com/services/api/keys/ ***');

    // Amazon S3
    // leave one or more of these constants empty to use local uploads
    define('AWS_ACCESS_KEY', '*** http://aws.amazon.com/ ***');
    define('AWS_SECRET_KEY', '');
    define('S3_BUCKET_ID',   '');

?>
