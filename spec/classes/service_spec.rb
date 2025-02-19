require 'spec_helper'

describe 'resolvconf::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} with use_systemd_resolved => true" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: true } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_service('systemd-resolved').with(
          'ensure' => 'running',
          'enable' => true,
        )
      }
    end

    context "on #{os} with use_systemd_resolved => false" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: false } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_service('systemd-resolved') }
    end
  end
end
