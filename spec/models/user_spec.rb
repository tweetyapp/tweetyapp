require 'spec_helper'

describe User do

	before(:each)do
		@attr = {:name=> "Eg user", :email => "eg@abc.com"}
	end
	it "Should create a new instance given a valid attr" do
		User.create!(@attr)
	end

	it "Should require a name" do
		test_user= User.new(@attr.merge(:name => ""))
		test_user.should_not be_valid
	end

	it "Should require an email" do
		test_user = User.new(@attr.merge(:email => ""))
		test_user.should_not be_valid
	end

	it "should reject names that are too long" do
		long_name = "a"*51
		long_name_user = User.create(@attr.merge(:name=> long_name))
		long_name_user.should_not be_valid
	end

	it "should accept valid email addrs" do
		addr = %w[user@abc.com THEUSER@foo.bar.org first.last@foo.jp]
		addr.each do |address|
			user1 = User.new(@attr.merge(:email => address))
			user1.should be_valid
		end
	end

	it "should reject invalid email" do
		addrs = %w[user@abc,om THEUSER_foo.bar.org first.last@foo.]
		addrs.each do |addr|
			invalid_user = User.new(@attr.merge(:email => addr))
			invalid_user.should_not be_valid
		end
	end

	it "should reject duplicate email add" do
		User.create!(@attr)
		user_dup = User.new(@attr)
		user_dup.should_not be_valid
	end

	it "should reject identical emails" do
		upcased_email =  @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_dup = User.new(@attr)
		user_dup.should_not be_valid
	end
end
