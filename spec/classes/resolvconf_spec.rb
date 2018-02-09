require 'spec_helper'

describe 'resolvconf' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('resolvconf::config') }

      it do
        case facts[:osfamily]
        when 'Debian'
          is_expected.to contain_class('resolvconf::install')
          is_expected.to contain_class('resolvconf::service')
        end
      end
    end
  end
end
