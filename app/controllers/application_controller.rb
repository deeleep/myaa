class ApplicationController < ActionController::Base
  def hello
    render html: "Hello World!"
  end

  def index
    render html: "Goood Bye world!"
  end
end
