require 'spec_helper'

describe 'freeradius' do
  on_supported_os.each do |os, facts|
    context "when on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_service('radiusd').with({
        :ensure => 'running',
        :enable => true,
      }) }

      it { is_expected.to contain_package('freeradius')
        .with_ensure(:present)
        .that_comes_before('Service[radiusd]')
      }
    end
  end
end
