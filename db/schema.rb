# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_12_17_213941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "firmwares", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firmware"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "image"
    t.string "imageable_type"
    t.integer "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "instruments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "permalink"
    t.text "description"
    t.string "brief_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manuals", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manual"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "permalink"
    t.string "title"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "permalink"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "model_number"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "manual"
    t.string "brief_description"
    t.integer "instrument_id"
    t.text "features"
    t.json "firmwares"
    t.json "manuals"
    t.index ["instrument_id"], name: "index_products_on_instrument_id"
    t.index ["model_number"], name: "index_products_on_model_number"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "authentication_token", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "products", "instruments"
end
