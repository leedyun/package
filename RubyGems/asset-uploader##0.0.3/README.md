# AssetUploader

Usage:

     asset_uploader  [ --no-upload | --no-sign ]  target_prefix  asset asset...

  Takes the files (or files under directories) named by asset... and uploads them
  to S3, renaming each file to include a checksum. Prints the path for each
  file uploaded.

  The target_prefix specifies where the file is stored on S3. 

  The --no-upload option prints the path but does not upload

  The --no-sign option uploads the file with no checksum. Files uploaded with
  no checksum will be hard to change, as the caching front end won't know they
  have changed

  You need to set the S3 credentials in your environment

      export AU_ACCESS_KEY_ID=...
      export SECRET_ACCESS_KEY=...
      export AU_BUCKET_NAME=...

  The default bucket name for assets is a-origin.pragprog.com

Examples

  asset_uploader  magazines/2012-06/images  images

  asset_uploader  --no-sign newsletter/2012-06-04 newsletter.html
  
## Installation

Add this line to your application's Gemfile:

    gem 'asset_uploader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asset_uploader

## Usage

TODO: Write usage instructions here


