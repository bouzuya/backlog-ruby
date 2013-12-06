require 'xmlrpc/client'
require 'uri'

class Backlog

  def initialize space_id, user, password
    uri = URI.parse "https://#{space_id}.backlog.jp/XML-RPC"
    proxy_host = nil
    proxy_port = nil
    use_ssl = true
    timeout = nil
    @client = XMLRPC::Client.new uri.host,
                                 uri.path,
                                 uri.port,
                                 proxy_host,
                                 proxy_port,
                                 user,
                                 password,
                                 use_ssl,
                                 timeout
  end

  def projects
    format_results @client.call 'backlog.getProjects'
  end

  def components project_id
    format_results @client.call 'backlog.getComponents', project_id
  end

  def versions project_id
    format_results @client.call 'backlog.getVersions', project_id
  end

  def users project_id
    format_results @client.call 'backlog.getUsers', project_id
  end

  def issue_types project_id
    format_results @client.call 'backlog.getIssueTypes', project_id
  end

  def comments issue_id
    format_results @client.call 'backlog.getComments', issue_id 
  end

  def find_issue project_id
    format_results @client.call 'backlog.findIssue', projectId: project_id
  end


  private

  def format_results results
    results.map {|r| format_result r }
  end

  def format_result result
    result.reduce({}) {|h, (k,v)|
      h[k.to_sym] = v
      h
    }
  end

end

backlog = Backlog.new ENV['BACKLOG_SPACE_ID'], ENV['BACKLOG_USERNAME'], ENV['BACKLOG_PASSWORD']
projects = backlog.projects
p projects

project_id = projects.first[:id]
p backlog.components project_id
p backlog.versions project_id
p backlog.users project_id
p backlog.issue_types project_id

issues = backlog.find_issue project_id
issue_id = issues.first[:id]

comments = backlog.comments issue_id
p comments


