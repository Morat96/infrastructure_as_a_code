describe service('docker') do
  it { should be_enabled }
end

describe port(80) do
  it { should be_listening }
end
