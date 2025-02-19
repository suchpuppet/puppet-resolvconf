require 'spec_helper'

describe 'resolvconf::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} with use_systemd_resolved => true" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: true } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_file('/etc/systemd/resolved.conf.d').with(
          'ensure' => 'directory',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        )

        is_expected.to contain_file('/etc/systemd/resolved.conf.d/puppet.conf').with(
          'ensure'  => 'file',
          'content' => %r{\[Resolve\]\nDNS=.*\nDomains=.*\n(FallbackDNS=.*\n)?DNSStubListener=(yes|no)\n(DNSStubListenerExtra=.*\n)?},
        )
      }

      it {
        is_expected.to contain_file('/etc/resolv.conf').with(
          'ensure' => 'symlink',
          'target' => '/run/systemd/resolve/stub-resolv.conf',
        )
      }

      it {
        is_expected.to contain_service('systemd-resolved').with(
          'ensure' => 'running',
          'enable' => true,
        )
      }
    end

    context "on #{os} with use_systemd_resolved => false, use_local => false, options => ['ndots:5']" do
      let(:facts) { os_facts }
      let(:params) { { use_systemd_resolved: false, use_local: false, options: ['ndots:5'] } }
      let(:hiera_config) { 'hiera.yaml' }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_file('/etc/resolv.conf').with(
          'ensure'  => 'file',
          'content' => %r{# Managed with Puppet. Resistance if futile.\nsearch example.com\nnameserver 8.8.8.8\nnameserver 1.1.1.1\nnameserver 2001:4860:4860::8888\noptions ndots:5},
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
        )
      }

      it { is_expected.not_to contain_file('/etc/systemd/resolved.conf.d') }
      it { is_expected.not_to contain_file('/etc/systemd/resolved.conf.d/puppet.conf') }
    end
  end
end
