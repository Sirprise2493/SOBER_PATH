# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_08_095259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_chat_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "is_ai_message", default: false, null: false
    t.text "message_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_ai_message"], name: "index_ai_chat_messages_on_is_ai_message"
    t.index ["user_id"], name: "index_ai_chat_messages_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "asker_id", null: false
    t.bigint "receiver_id", null: false
    t.integer "status_of_friendship_request", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asker_id", "receiver_id"], name: "index_friendships_on_asker_id_and_receiver_id", unique: true
    t.index ["asker_id"], name: "index_friendships_on_asker_id"
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.check_constraint "asker_id <> receiver_id", name: "chk_friendships_not_self"
  end

  create_table "journal_contents", force: :cascade do |t|
    t.text "content", null: false
    t.text "motivational_text"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_journal_contents_on_user_id"
  end

  create_table "user_chat_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_user_chat_messages_on_created_at"
    t.index ["user_id"], name: "index_user_chat_messages_on_user_id"
  end

  create_table "user_chat_messages_responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_chat_message_id", null: false
    t.text "message_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_chat_message_id"], name: "index_user_chat_messages_responses_on_user_chat_message_id"
    t.index ["user_id"], name: "index_user_chat_messages_responses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username", null: false
    t.date "date_of_birth", null: false
    t.string "address"
    t.string "email", null: false
    t.string "headline"
    t.text "bio"
    t.date "sobriety_start_date"
    t.boolean "counsellor", default: false, null: false
    t.datetime "messaging_suspended_until"
    t.integer "strike_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_chat_messages", "users"
  add_foreign_key "friendships", "users", column: "asker_id"
  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "journal_contents", "users"
  add_foreign_key "user_chat_messages", "users"
  add_foreign_key "user_chat_messages_responses", "user_chat_messages"
  add_foreign_key "user_chat_messages_responses", "users"
end
