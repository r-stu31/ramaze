#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

class TCStackHelperController < Ramaze::Controller
  map :/
  helper :stack, :aspect

  def index
    session.inspect
  end

  def foo
    call Rs(:login) unless logged_in?
    "logged in"
  end

  def bar
    call Rs(:login) unless logged_in?
    request.params.inspect
  end

  def secure
    logged_in? ? 'secret content' : 'please login'
  end

  def login
    session[:logged_in] = true
    answer
  end

  def logout
    session.clear
  end

  private

  def logged_in?
    session[:logged_in]
  end
end

describe "StackHelper" do
  ramaze(:adapter => :webrick)

  it "conventional login" do
    browser do
      get('/secure').should == 'please login'
      get('/login')
      get('/secure').should == 'secret content'
      get('/logout')
    end
  end

  it "indirect login" do
    browser do
      get('/foo').should == 'logged in'
      get('/foo').should == 'logged in'
      eget('/').should == {:logged_in => true, :STACK => []}
    end
  end

  it "indirect login with params" do
    browser do
      eget('/bar', 'x' => 'y').should == {'x' => 'y'}
      eget('/').should == {:logged_in => true, :STACK => []}
    end
  end
end