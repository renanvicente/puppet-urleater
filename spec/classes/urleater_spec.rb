require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'urleater' do

  let(:title) { 'urleater-get' }
  let(:node) { 'rspec.renanvicente.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    let(:params) { {:port => '7777', :server => 'renanvicente.com', } }
    it { should contain_vcsrepo('urleater-get').with_ensure('present') }
    it { should contain_service('urleater-get').with_ensure('running') }
    it { should contain_service('urleater-get').with_enable('true') }
    it { should contain_file('/etc/urleater-get.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific customer' do
    let(:params) { {:port => '7777', :server => 'renanvicente.com', :customer => 'renanvicente' } }
    it { should contain_vcsrepo('urleater-get').with_ensure('present') }
    it { should contain_service('urleater-get').with_ensure('running') }
    it { should contain_service('urleater-get').with_enable('true') }
    it { should contain_file('/etc/urleater-get.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific customer and direcory' do
    let(:params) { {:port => '7777', :server => 'renanvicente.com', :customer => 'renanvicente', :vhost_directory => '/tmp' } }
    it { should contain_vcsrepo('urleater-get').with_ensure('present') }
    it { should contain_service('urleater-get').with_ensure('running') }
    it { should contain_service('urleater-get').with_enable('true') }
    it { should contain_file('/etc/urleater-get.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0' } }
    it { should contain_vcsrepo('urleater-get').with_ensure('1.0') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true,} }
    it 'should remove Vcsrepo[urleater-get]' do should contain_vcsrepo('urleater-get').with_ensure('absent') end
    it 'should stop Service[urleater-get]' do should contain_service('urleater-get').with_ensure('stopped') end
    it 'should not enable at boot Service[urleater-get]' do should contain_service('urleater-get').with_enable('false') end
    it 'should remove urleater configuration file' do should contain_file('/etc/urleater-get.conf').with_ensure('absent') end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, } }
    it { should contain_vcsrepo('urleater-get').with_ensure('present') }
    it 'should stop Service[urleater-get]' do should contain_service('urleater-get').with_ensure('stopped') end
    it 'should not enable at boot Service[urleater-get]' do should contain_service('urleater-get').with_enable('false') end
    it { should contain_file('/etc/urleater-get.conf').with_ensure('present') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, } }
    it { should contain_vcsrepo('urleater-get').with_ensure('present') }
    it { should_not contain_service('urleater-get').with_ensure('present') }
    it { should_not contain_service('urleater-get').with_ensure('absent') }
    it 'should not enable at boot Service[urleater-get]' do should contain_service('urleater-get').with_enable('false') end
    it { should contain_file('/etc/urleater-get.conf').with_ensure('present') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, } }
    it { should contain_vcsrepo('urleater-get').with_noop('true') }
    it { should contain_service('urleater-get').with_noop('true') }
    it { should contain_file('/etc/urleater-get.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "urleater/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
     should contain_file('/etc/urleater-get.conf').with_content(/This is a template used only for rspec tests/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('/etc/urleater-get.conf').with_content(/value_a/)
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "urleater::spec" } }
    it { should contain_file('/etc/urleater-get.conf').with_content(/rspec.renanvicente.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      should contain_file('/etc/urleater-get.conf').with_enable(nil)
    end
  end


end

