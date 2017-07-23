require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do
    it "is invalid without amount" do
      parking = Parking.new(:parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :end_at => Time.now)
      expect( parking).to_not be_valid
    end

    it "is invalid without end_at" do
      parking = Parking.new( :parking_type => "guest",
                             :start_at => Time.now - 6.hours,
                             :amount => 999)
      expect( parking).to_not be_valid
    end
  end

  describe ".calculate_amount" do
    before do
      @time = Time.new(2017,3 ,27, 8, 0, 0)
    end
    context "guest" do
      before do
        @parking = Parking.new(:parking_type => "guest", :user => @user, :start_at => @time)
      end
      it "30 mins should be ¥2" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t +30.minutes)
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t + 60.minutes)
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥3" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t + 61.minutes)
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "90 mins should be ¥3" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t + 90.minutes)
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end

      it "120 mins should be ¥4" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t + 120.minutes)
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(400)
      end
    end

    context "short-term" do
      before do
        @user = User.create(:email => "test@example.com", :password => "123456")
        @parking = Parking.new(:parking_type => "short-term", :user => @user, :start_at => @time)
      end
      it "30 mins should be ¥2" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "shourt-term", :start_at => t, :end_at => t + 30.minutes)
        # parking.user = User.create(:email => "test@example.com", :password => "123456")
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be ¥2" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "shourt-term", :start_at => t, :end_at => t + 60.minutes)
        # parking.user = User.create(:email => "test@example.com", :password => "123456")
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥2.5" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "shourt-term", :start_at => t, :end_at => t + 61.minutes)
        # parking.user = User.create(:email => "test@example.com", :password => "123456")
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)
      end

      it "90 mins should be ¥2.5" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "shourt-term", :start_at => t, :end_at => t + 90.minutes)
        # parking.user = User.create(:email => "test@example.com", :password => "123456")
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)
      end

      it "120 mins should be ¥3" do
        # t = Time.now
        # parking = Parking.new(:parking_type => "shourt-term", :start_at => t, :end_at => t + 120.minutes)
        # parking.user = User.create(:email => "test@example.com", :password => "123456")
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)
      end
    end

    context "long-term" do
      before do
        @user = User.create(:email => "test@example.com", :password => "123456")
        @parking = Parking.new(:parking_type => "long-term", :user => @user, :start_at => @time)
      end
      it "360 mins should be ¥12" do
        @parking.end_at = @time + 360.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(1200)
      end

      it "1440 mins should be ¥16" do
        @parking.end_at = @time + 1440.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(1600)
      end

      it "1441 mins should be ¥32" do
        @parking.end_at = @time + 1441.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(3200)
      end

      it "2880 mins should be ¥32" do
        @parking.end_at = @time + 2880.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(3200)
      end

      it "2881 mins should be ¥48" do
        @parking.end_at = @time + 2881.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(4800)
      end
    end

  end
end
