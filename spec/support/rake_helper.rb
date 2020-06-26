def run_task(task_name:, args:)
  Rake::Task[task_name].reenable
  Rake::Task[task_name].invoke args
end

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
