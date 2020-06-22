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

ActiveRecord::Schema.define(version: 2019_08_13_150730) do

  create_table "bouquets", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "recipient_name"
    t.integer "bouquet_id"
    t.integer "shipping_option_id"
    t.integer "order_id"
    t.date "delivery_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bouquet_id"], name: "index_deliveries_on_bouquet_id"
    t.index ["order_id"], name: "index_deliveries_on_order_id"
    t.index ["shipping_option_id"], name: "index_deliveries_on_shipping_option_id"
  end

  create_table "order_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "recipient_name"
    t.integer "bouquet_id"
    t.integer "order_type_id"
    t.integer "shipping_option_id"
    t.date "first_delivery_date"
    t.string "state", default: "billed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bouquet_id"], name: "index_orders_on_bouquet_id"
    t.index ["order_type_id"], name: "index_orders_on_order_type_id"
    t.index ["shipping_option_id"], name: "index_orders_on_shipping_option_id"
  end

  create_table "shipping_options", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
