require 'spec_helper'

describe 'resolvconf::config' do
  on_supported_os.each do |os, os_facts|

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_file('/etc/resolvconf').with({
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        }) }
        it { is_expected.to contain_file('/etc/resolvconf/resolv.conf.d').with({
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        }) }
        it { is_expected.to contain_file('/etc/resolvconf/resolv.conf.d/tail').with({
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
        }) }
        it { is_expected.to contain_file('/etc/resolv.conf').with({
          'ensure' => 'symlink',
          'target' => '/var/run/resolvconf/resolv.conf',
          'owner'  => 'root',
          'group'  => 'root',
        }) }
      end
    end
  end
end
