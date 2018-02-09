require 'spec_helper'

describe 'resolvconf::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('resolvconf') }
      end
    end
  end
end
