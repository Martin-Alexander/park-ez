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

ActiveRecord::Schema.define(version: 2019_07_11_202853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emplacement_reglementations", force: :cascade do |t|
    t.bigint "place_id"
    t.bigint "reglementation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_emplacement_reglementations_on_place_id"
    t.index ["reglementation_id"], name: "index_emplacement_reglementations_on_reglementation_id"
  end

  create_table "periodes", force: :cascade do |t|
    t.time "heure_debut"
    t.time "heire_fin"
    t.boolean "applique_lundi"
    t.boolean "applique_mardi"
    t.boolean "applique_mercredi"
    t.boolean "applique_jeudi"
    t.boolean "applique_vendredi"
    t.boolean "applique_samedi"
    t.boolean "applique_dimanche"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.float "longitude"
    t.float "latitude"
    t.string "statut"
    t.string "genre"
    t.string "place_type"
    t.string "autre_tete"
    t.string "nom_rue"
    t.integer "sup_velo"
    t.string "type_exploitation"
    t.float "postion_centre_longitude"
    t.float "postion_centre_latitude"
    t.integer "tarif_horaire"
    t.string "localisation"
    t.integer "tarif_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reglementation_periodes", force: :cascade do |t|
    t.bigint "reglementation_id"
    t.bigint "periode_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["periode_id"], name: "index_reglementation_periodes_on_periode_id"
    t.index ["reglementation_id"], name: "index_reglementation_periodes_on_reglementation_id"
  end

  create_table "reglementations", force: :cascade do |t|
    t.string "type_reglementation"
    t.integer "date_debut"
    t.integer "date_fin"
    t.integer "duree_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "emplacement_reglementations", "places"
  add_foreign_key "emplacement_reglementations", "reglementations"
  add_foreign_key "reglementation_periodes", "periodes"
  add_foreign_key "reglementation_periodes", "reglementations"
end
