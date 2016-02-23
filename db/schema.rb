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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160223041929) do

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id", null: false
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "articles", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "body"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "choice"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "discussions", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.string   "title",                     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "body"
    t.string   "logo"
    t.string   "cover"
    t.integer  "watches_count", default: 0
    t.string   "slug",                      null: false
  end

  add_index "issues", ["slug"], name: "index_issues_on_slug", unique: true

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["post_id"], name: "index_likes_on_post_id"
  add_index "likes", ["user_id", "post_id"], name: "index_likes_on_user_id_and_post_id", unique: true
  add_index "likes", ["user_id"], name: "index_likes_on_user_id"

  create_table "old_users", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nickname",   null: false
  end

  add_index "old_users", ["email"], name: "index_old_users_on_email", unique: true
  add_index "old_users", ["nickname"], name: "index_old_users_on_nickname", unique: true

  create_table "opinions", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parti_sso_client_api_keys", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.string   "digest",                            null: false
    t.string   "client",                            null: false
    t.integer  "authentication_id",                 null: false
    t.datetime "expires_at",                        null: false
    t.datetime "last_access_at",                    null: false
    t.boolean  "is_locked",         default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "parti_sso_client_api_keys", ["client"], name: "index_parti_sso_client_api_keys_on_client"
  add_index "parti_sso_client_api_keys", ["user_id", "client"], name: "index_parti_sso_client_api_keys_on_user_id_and_client", unique: true

  create_table "posts", force: :cascade do |t|
    t.integer  "issue_id",                               null: false
    t.integer  "postable_id",                            null: false
    t.string   "postable_type",                          null: false
    t.integer  "user_id",                                null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "touched_at",                             null: false
    t.integer  "likes_count",         default: 0
    t.string   "last_touched_action", default: "create"
    t.string   "last_touched_params"
    t.integer  "comments_count",      default: 0
    t.integer  "votes_count",         default: 0
  end

  add_index "posts", ["issue_id"], name: "index_posts_on_issue_id"
  add_index "posts", ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "proposals", force: :cascade do |t|
    t.integer  "discussion_id", null: false
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "proposals", ["discussion_id"], name: "index_proposals_on_discussion_id"

  create_table "questions", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "redactor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "nickname",                                 null: false
    t.string   "image"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                                      null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "votes", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "choice",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "post_id",    null: false
  end

  add_index "votes", ["post_id", "user_id"], name: "index_votes_on_post_id_and_user_id", unique: true
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

  create_table "watches", force: :cascade do |t|
    t.integer  "issue_id",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "watches", ["issue_id"], name: "index_watches_on_issue_id"
  add_index "watches", ["user_id", "issue_id"], name: "index_watches_on_user_id_and_issue_id", unique: true
  add_index "watches", ["user_id"], name: "index_watches_on_user_id"

end
