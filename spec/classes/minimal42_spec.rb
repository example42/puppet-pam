require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'pam' do

  let(:title) { 'pam' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_file('pam.conf').with_ensure('present') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_file('pam.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "pam/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'pam.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'pam.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/pam/spec"} }
    it { should contain_file('pam.conf').with_source('puppet:///modules/pam/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/pam/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('pam.dir').with_source('puppet:///modules/pam/dir/spec') }
    it { should contain_file('pam.dir').with_purge('true') }
    it { should contain_file('pam.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "pam::spec" } }
    it { should contain_file('pam.conf').with_content(/rspec.example42.com/) }
  end

end
