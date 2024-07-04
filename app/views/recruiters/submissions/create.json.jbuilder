json.status     @status
json.message    @message

unless @success.blank?
    json.data do
        json.job do
            json.title          @submission.job.title
            json.description    @submission.job.description
            json.start_date     @submission.job.start_date
            json.end_date       @submission.job.end_date
            json.status         @submission.job.status
            json.skills         @submission.job.skills
        end
        json.candidate do
            json.name           @submission.candidate.name
            json.email          @submission.candidate.email
            json.mobile_phone   @submission.candidate.mobile_phone
            json.resume         @submission.candidate.resume
        end
    end
end