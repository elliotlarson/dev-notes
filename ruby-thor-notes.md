# Ruby Thor Notes

## Integration Testing The Output

We need to load the file and then capture the standard out.

This assumes the command uses something like `puts` to spit out a value.

In order to execute the task, we use the Thor `invoke` method.

```ruby
require('rails_helper')

Thor::Util.load_thorfile('lib/tasks/rxnorm_related_codes.thor')

def capture_stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = STDOUT
end

RSpec.describe('my_thor_command') do
  subject do
    capture_stdout do
      Thor.new.invoke('my_thor_command', [], verbose: true)
    end
  end

  let(:expected_output) do
    <<~HDOC
      => good stuff
    HDOC
  end

  it { is_expected.to eq(expected_output) }
end
```
