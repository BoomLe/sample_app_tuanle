require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
      test "login with invalid information" do
        #1. john website
        get login_path
        assert_template "sessions/new"

        #2 login empty
        post login_path, params: { session: { email: "", password: "" } }

        #3 check unprocessable_enity
        assert_response :unprocessable_entity
        assert_template 'sessions/new'

        #4 check the signal table
         assert_not flash.empty?

        #5 return home
        get root_path

        #6 check the signal table is clear
        assert flash.empty?

      end
end
