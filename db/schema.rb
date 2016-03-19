# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160319113349) do

  create_table "app_versions", :force => true do |t|
    t.integer  "beta_version",          :default => 0,               :null => false
    t.string   "app_name",              :default => "",              :null => false
    t.string   "version",               :default => "",              :null => false
    t.string   "short_version",         :default => "",              :null => false
    t.datetime "release_date"
    t.text     "change_log",            :default => "",              :null => false
    t.string   "ipa_path",                                           :null => false
    t.string   "dsym_path"
    t.string   "icon_path"
    t.string   "itunes_artwork_path"
    t.string   "uploader_email",        :default => "unknown email", :null => false
    t.integer  "app_id",                                             :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "external_manifest_url"
  end

  add_index "app_versions", ["app_id"], :name => "index_app_versions_on_app_id"
  add_index "app_versions", ["app_name"], :name => "index_app_versions_on_app_name"
  add_index "app_versions", ["beta_version"], :name => "index_app_versions_on_beta_version"
  add_index "app_versions", ["release_date"], :name => "index_app_versions_on_release_date"
  add_index "app_versions", ["short_version"], :name => "index_app_versions_on_short_version"
  add_index "app_versions", ["version"], :name => "index_app_versions_on_version"

  create_table "apps", :force => true do |t|
    t.string   "bundle_id",    :default => "", :null => false
    t.integer  "last_version", :default => 0,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "apps", ["bundle_id"], :name => "index_apps_on_bundle_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
