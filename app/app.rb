# require 'httparty'
require 'json'
require 'aws-sdk-s3'
require 'base64'
require 'securerandom'

def gyazo_upload(event:, context:)
  body = event['body']
  body = Base64.decode64(body) if event['isBase64Encoded']
  key = SecureRandom.urlsafe_base64
  object = Aws::S3::Resource
             .new(region:ENV['REGION'])
             .bucket(ENV['BUCKET_NAME'])
             .put_object({ key: "#{key}.png", content_type: 'image/png', body: body })
  {
    statusCode: 200,
    body: object.public_url
  }
end
