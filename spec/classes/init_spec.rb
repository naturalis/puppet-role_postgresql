require 'spec_helper'
describe 'role_postgresql' do

  context 'with defaults for all parameters' do
    it { should contain_class('role_postgresql') }
  end
end
