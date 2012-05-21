require 'spec_helper'

describe User do

	before(:each)do
		@attr = {
			:name=> "Eg user",
			:email => "eg@abc.com",
			:password => "password",
			:password_confirmation => "password"
		}
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

	describe "passwords" do
		before(:each) do
			@user= User.new(@attr)
		end
		it "should have password attribute" do
			@user.should respond_to(:password)
		end
		it "should have a password confimation attr" do
			@user.should respond_to(:password_confirmation)
		end

	end

	describe "password validation" do
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end

		it "should require a matching password confimation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
		end

		it "should reject short passwords" do
			short = "z"*5
			hash = @attr.merge(:password =>short, :password_confirmation =>short)
			User.new(hash).should_not be_valid
		end
		
		it "should reject long passwords" do
			long = "z"* 41
			hash = @attr.merge(:password =>long, :password_confirmation =>long)
			User.new(hash).should_not be_valid
		end

	end

	describe "password encryption" do

		before(:each) do
			@user= User.create!(@attr)
		end

		it "should have an encrypted password" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end

		it "should have a salt" do
			@user.should respond_to(:salt)
		end

		describe "has_password?" do
			it "should exists" do
				@user.should respond_to(:has_password?)
			end

			it "should return true if passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "should return false if passwords do not match" do
				@user.has_password?("invalid").should be_false
			end

		end

		describe "authenticate method" do

			it "should exists" do
				User.should respond_to(:authenticate)
			end
			it "should return nil on email/password mismatch" do
				User.authenticate(@attr[:email], "invalid").should be_nil
			end

			it "should return nil " do
				User.authenticate("eg@abc.com",@attr[:password])
			end

			it "should return the user on match" do
				User.authenticate(@attr[:email],@attr[:password]).should == @user
			end
		end
	end
end
