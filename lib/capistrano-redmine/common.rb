# -*- encoding: utf-8 -*-
module Capistrano
  module Redmine

    def Redmine.configure(site, token)
      RedmineClient::Base.configure do
        self.site     = site
        self.format   = :xml
        self.user     = token
        self.password = ""
      end
    end

    def Redmine.update(site, token, projects, from_status, to_status, logger)
      Redmine.configure(site, token)
      projects = [projects] unless projects.is_a? Array

      projects.each do |p|

        unless p.is_a? String
          logger.important "Redmine error: Argument 'redmine_projects' type error."
          return
        end

        begin
          RedmineClient::Project.find(p)
        rescue ActiveResource::UnauthorizedAccess
          logger.important "Redmine error: Unauthorized Access. Check token."
          return          
        rescue ActiveResource::ResourceNotFound
          logger.important "Redmine error: Project not found."
          return
        end

        statuses = RedmineClient::IssueStatus.find(:all).inject({}) do |memo, s|
          memo.merge s.id => s.name
        end

        if statuses[from_status.to_s].nil? || statuses[to_status.to_s].nil?
          logger.important "Redmine error: Invalid issue status (or statuses)."
          return
        end

        begin
          issues = RedmineClient::Issue.find(:all, :params => {
            :project_id => p,
            :status_id => from_status,
            :limit => 100
            }
          )

          issues.each do |i|
            i.status_id = to_status
            i.save
            logger.debug "Update ##{i.id} #{i.subject}"
          end
        rescue ActiveResource::ResourceInvalid
          logger.important "Redmine error: Update issue error."
        end
      end
    end
  end
end


configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

  namespace :redmine do
    desc "Update Redmine issues statuses."
    task :update, :roles => :app, :except => { :no_release => true } do
      Capistrano::Redmine.update(
        redmine_site,
        redmine_token,
        redmine_projects,
        redmine_from_status,
        redmine_to_status,
        logger
      )
    end
  end

end
