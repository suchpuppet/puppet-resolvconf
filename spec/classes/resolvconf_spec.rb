require 'spec_helper'

describe 'resolvconf' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('resolvconf::config') }
      it { is_expected.to contain_class('resolvconf::install') }
      it { is_expected.to contain_class('resolvconf::service') }

      if os_facts[:os]['distro']['id'] == 'Ubuntu' && os_facts[:os]['distro']['release']['major'].to_i >= 24
        it { is_expected.to contain_service('systemd-resolved').with(
          'ensure' => 'running',
          'enable' => true,
        ) }
      end
    end
  end
end
