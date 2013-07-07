# coding: UTF-8

require_relative 'spec_helper'

def javascript_tag(str)
  "<s>#{str}</s>".tap do |s|
    s.class.send(:define_method, :html_safe, ->{ self })
  end
end

describe 'AngularJS::Rails::Cdn::ActionViewExtensions' do
  subject { Class.new.extend(AngularJS::Rails::Cdn::ActionViewExtensions) }

  describe 'angularjs_url' do
    context :google do
      it 'returns url with version without specific module name' do
        subject.angularjs_url(:google, 'angular', '1.0.7').should == '//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js'
      end
    end
  end

  describe :modules do
    it 'returns default modules list' do
      subject.send(:modules, nil).should == [:angular]
    end

    it 'returns extended modules list' do
      subject.send(:modules, [:resource, :cookies]).should == [:angular, :'angular-resource', :'angular-cookies']
    end
  end

  describe :angularjs_include_tag do
    before do
      subject.should_receive(:javascript_include_tag).with(:angular).and_return('<s>angular.js</s>')
    end

    context 'offline mode' do
      context 'no additional modules' do
        it { subject.angularjs_include_tag(:google).should == '<s>angular.js</s>' }
        it { subject.angularjs_include_tag(:google, version: '1.0.7').should == '<s>angular.js</s>' }
      end

      context 'with additional module' do
        before { subject.should_receive(:javascript_include_tag).with(:'angular-cookies').and_return('<s>angular-cookies.js</s>') }

        it { subject.angularjs_include_tag(:google, modules: [:cookies]).should == '<s>angular.js</s><s>angular-cookies.js</s>' }
        it { subject.angularjs_include_tag(:google, version: '1.0.7', modules: [:cookies]).should == '<s>angular.js</s><s>angular-cookies.js</s>' }
      end
    end

    context 'CDN is enforced' do
      before do
        subject.should_receive(:javascript_include_tag).with('//ajax.googleapis.com/ajax/libs/angularjs/1.1.5/angular.min.js').and_return('<s>//angular.min.js</s>')
      end

      context 'no additional modules' do
        it { subject.angularjs_include_tag(:google, force: true, version: '1.1.5').should == "<s>//angular.min.js</s><s>window.angular || document.write(unescape('%3Cs>angular.js%3C/s>'))</s>" }
      end

      context 'with submodule' do
        before do
          subject.should_receive(:javascript_include_tag).with(:'angular-cookies').and_return('<s>angular-cookies.js</s>')
          subject.should_receive(:javascript_include_tag).with('//ajax.googleapis.com/ajax/libs/angularjs/1.1.5/angular-cookies.min.js').and_return('<s>//angular-cookies.min.js</s>')
        end

        it { subject.angularjs_include_tag(:google, force: true, version: '1.1.5', modules: [:cookies]).should == "<s>//angular.min.js</s><s>//angular-cookies.min.js</s><s>window.angular || document.write(unescape('%3Cs>angular.js%3C/s>%3Cs>angular-cookies.js%3C/s>'))</s>" }
      end
    end
  end
end
