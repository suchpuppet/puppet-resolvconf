require 'spec_helper'

describe 'resolvconf::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} with use_systemd_resolved => true" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: true } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }

      if os_facts[:os]['distro']['id'] == 'Ubuntu' && os_facts[:os]['distro']['release']['major'].to_i >= 24
        it { is_expected.to contain_package('systemd-resolved').with_ensure('latest') }
      end
    end

    context "on #{os} with use_systemd_resolved => false" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: false } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_package('systemd-resolved') }
    end
  end
end
