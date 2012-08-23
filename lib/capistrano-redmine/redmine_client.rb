# -*- encoding: utf-8 -*-
require 'net/http'
require 'json'

module RedmineClient

  class Base
    HTTP_GET = 'GET'
    HTTP_PUT = 'PUT'

    module ClassMethods
      attr_accessor :site, :format, :token, :ssl_options, :proxy

      def configure(&block)
        instance_eval &block
      end

      def http(resource, params = {}, method = HTTP_GET)
        uri = URI("#{site}/#{resource}.#{format}")
        http = Net::HTTP.new(uri.host, uri.port)

        case method
        when HTTP_GET
          params[:key] = token                            # add key to GET-params
          uri.query = URI.encode_www_form(params)         # GET-params including key
          request = Net::HTTP::Get.new(uri.request_uri)
        when HTTP_PUT
          uri.query = URI.encode_www_form({key: token })  # GET-params is only key
          request = Net::HTTP::Put.new(uri.request_uri)
          request.set_form_data(params)                   # PUT-params without key
        end

        if http.use_ssl = ssl_options ? true : false
          http.cert = ssl_options[:cert]
          http.key = ssl_options[:key]
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        http.request(request)
      end

    end

    extend ClassMethods
  end

  class Project < RedmineClient::Base

    module ClassMethods
      def all
        resource = 'projects'
        http = Base.http(resource)

        begin
          JSON.parse(http.body)[resource]
        rescue JSON::ParserError
          false
        end
      end

      def find(project_id)
        http = Base.http("projects/#{project_id}")

        begin
          JSON.parse(http.body)['project']
        rescue JSON::ParserError
          false
        end
      end
    end

    extend ClassMethods
  end

  class Issue < RedmineClient::Base
    module ClassMethods
      def all(params = {})
        resource = 'issues'
        http = Base.http(resource, params)

        begin
          JSON.parse(http.body)[resource]
        rescue JSON::ParserError
          false
        end
      end

      def update(issue_id, params = {})
        http = Base.http("issues/#{issue_id}", params, Base::HTTP_PUT)
      end
    end
    extend ClassMethods
  end

  class IssueStatus < RedmineClient::Base
    module ClassMethods
      def all
        resource = 'issue_statuses'
        http = Base.http(resource)

        begin
          JSON.parse(http.body)[resource]
        rescue JSON::ParserError
          false
        end
      end
    end
    extend ClassMethods
  end

end
