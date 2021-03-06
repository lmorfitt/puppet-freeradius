require 'spec_helper'

describe 'freeradius::mod' do
  let(:title) { 'perl' }
  let(:pre_condition) do
    "include freeradius"
  end

  on_supported_os.each do |os, facts|
    context "when on #{os}" do
      context 'when passing no parameters' do
        it 'should fail' do
          expect { is_expected.to compile }.to raise_error(/Must pass content/)
        end
      end

      context 'when passing content' do
        let(:params) { {
          :content => 'foo',
        } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/raddb/mods-enabled/perl').with({
            :ensure  => :file,
            :owner   => 'root',
            :group   => 'radiusd',
            :mode    => '0640',
            :content => 'foo',
          })
        }

        it 'should require package and notify service' do
          is_expected.to contain_file('/etc/raddb/mods-enabled/perl')
          .that_requires('Package[freeradius]')
          .that_notifies('Service[radiusd]')
        end
      end

      context 'when ensuring absence' do
        let(:params) { {
          :ensure => 'absent',
        } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/raddb/mods-enabled/perl').with_ensure(:absent) }
      end

      context 'when passing package' do
        let(:params) { {
          :content => 'foo',
          :package => 'bar',
        } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('bar').with_ensure(:present) }

        it 'should come before module file' do
          is_expected.to contain_package('bar').that_comes_before('File[/etc/raddb/mods-enabled/perl]')
        end
      end
    end
  end
end
