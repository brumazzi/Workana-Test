json.status @status
json.message @message

unless @job.blank?
    json.data do
        json.id             @job.id
        json.title          @job.title
        json.description    @job.description
        json.start_date     @job.start_date
        json.skills         @job.skills
    end
end