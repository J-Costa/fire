require 'test_helper'
require 'rake'

Rails.application.load_tasks

class CertificatesRakeTest < ActiveSupport::TestCase
  setup do
    @task = Rake::Task['certificates:expire']
    @task.reenable
  end

  test 'expire marks active certificates past expiration' do
    certificate = certificates(:active)
    certificate.update_column(:expires_at, 1.day.ago)

    output = capture_io { @task.invoke }.first

    assert_equal 'expired', certificate.reload.status
    assert_includes output, '[Certificates] 1 certificate(s) marked as expired'
  end
end