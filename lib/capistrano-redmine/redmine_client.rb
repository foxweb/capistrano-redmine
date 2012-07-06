# -*- encoding: utf-8 -*-
module RedmineClient
  class Base < ActiveResource::Base

    def self.configure(&block)
      instance_eval &block
    end

  end

  class Project < RedmineClient::Base
  end

  class Issue < RedmineClient::Base
  end

  class IssueStatus < RedmineClient::Base
  end

end
