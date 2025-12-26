require_relative "lang_cards/version"
require_relative "lang_cards/create_new_db"
require_relative "lang_cards/lang_card_class"
require_relative "lang_cards/instructions_about"
require 'green_shoes'
require 'yaml/store'

include NewDB
include LangCard
include Instructions

###################
# Shoes app start #
###################
Shoes.app width: 800, height: 1050,
title: "LangCards" do

  @store_for_all_dbs = YAML::Store.new("store_for_all_dbs.store")

  $db = YAML::Store.new("default.store")

#####################################################
# Instructions, About and listing of all FlashCards #
#####################################################
  flow width: 800 do
    caption "Instructions", margin_left: 5
    background papayawhip
    button "Instructions", margin: 5 do
      window title: "Instructions", width: 600, height: 1200 do
      background lavender
      para INSTRUCTIONS
      end
    end

    button "About", margin: 5 do
      window title: "About", widht: 200, height: 200, margin: 20 do
      background lavender
      para ABOUT
      end
    end

    button "List all flashcard", margin: 5 do
      if $db
        window title: "All flashcards" do
        background lavender
            $db.transaction(true) do
              @all_cards = $db.roots
              @all_cards.sort!
              @all_cards.each_with_index do |c,i|
                str = "  #{i+1}. #{c}"
                edit_line text: str, state: 'readonly'
              end
            end
        end
      else
        alert "No database is active!"
      end
    end
  end
#########################################################
# Instructions, About and listing of all FlashCards end #
#########################################################


#################################
# Database creation flow start #
#################################
  flow do
  caption "Database creation", margin: 5
  background lightgrey
    @new_db_entry_field = edit_line margin: 5
    button "Create new database", margin: 5 do
      @new_db = @new_db_entry_field.text
      create_new_db(@new_db, @store_for_all_dbs)
      @new_db_entry_field.text = ""

      @store_for_all_dbs.transaction(true) do
        @list_of_all_dbs.items = @store_for_all_dbs.roots
    end
    end
  end
##############################
# Database creation flow end #
##############################


#################################
# Database selection flow start #
#################################
  flow do
    caption "Database selection", margin: 5
    background lightsteelblue

    @list_of_all_dbs = list_box margin: 5

    @store_for_all_dbs.transaction(true) do
      @list_of_all_dbs.items = @store_for_all_dbs.roots
    end

    button "Activate the selected database", margin: 5 do
      @selected_database = @list_of_all_dbs.text
      $db = YAML::Store.new("#{@selected_database}.store")

      $db.transaction(true) do
      @all_cards_list.items = $db.roots
      end
    end
  end
###############################
# Database selection flow end #
###############################


#######################################
# Stack for the Create function start #
#######################################
  stack width: 800 do
    background antiquewhite
    caption "Create"

      flow width: 800, margin: 5 do
        para "Name:", width: 150; @name = edit_line
        para "Source:", width: 150; @source = edit_line
        para "Target:", width: 150; @target = edit_line
        para "Part of speech:", width: 150; @part_of_speech = list_box items:
             [" ", "verb", "noun", "adjective", "adverb", "pronoun",
              "preposition", "conjunction", "interjection"], choose: " "
        para "Example:", width: 150; @example = edit_line

        button "Save/update flashcard", margin_top: 30, margin_bottom: 20 do
          card = Card.new(@name.text, @source.text, @target.text,
          @part_of_speech.text, @example.text)

          unless card.name == ""
            $db.transaction do
              $db[card.name] = card
              $db_roots = $db.roots
            end

            $db.transaction(true) do
              @all_cards = $db.roots
            end

            $db.transaction do
              @all_cards_list.items = $db.roots
            end

            # Clear the input fields after save or update
            @name.text = ""
            @source.text = ""
            @target.text = ""
            @part_of_speech.choose " "
            @example.text = ""
            alert("Flashcard saved successfully.")
          else
            alert("Enter Name, please!")
          end
        end
      end
    end

#####################################
# Stack for the Create function end #
#####################################


########################################################
# Stack for the Read, Update and Delete functions start #
########################################################
  stack do
    background powderblue
    stack margin: 10 do
    caption "Read, Update and Delete"
      para "Select flashcard to delete from the database or to retrieve it for update:"

      @all_cards_list = list_box

      button "Delete from database" do
        $db.transaction do
          if @all_cards_list.items.empty?
            alert("No flashcard is selected.")
          else
            del = @all_cards_list.text
            $db.delete(del)
          end
        end
        $db.transaction do
        @all_cards_list.items = $db.roots
        end
      end

      button "Retrieve for update" do
        $db.transaction(true) do
          abc = @all_cards_list.text
          if @all_cards_list.items.empty?
            alert("No flashcard is selected.")
          else
            @name.text = abc
            @source.text = $db[abc].source
            @target.text = $db[abc].target
            @part_of_speech.choose($db[abc].part_of_speech)
            @example.text = $db[abc].example
          end
        end
      end
    end
  end
#######################################################
# Stack for the Read, Update and Delete functions end #
#######################################################


########################
# Learning stack start #
########################
  stack width: 800, height: 550, margin: 10 do
    background rosybrown
    caption "Learn"
    button "Select random flashcard" do
      $db.transaction(true) do
          @all_cards = $db.roots
          if @all_cards.empty?
            alert("Database is empty.")
          else
            samp_name = @all_cards.sample
            samp_source = $db[samp_name].source
            samp_target = $db[samp_name].target
            samp_part_of_speech = $db[samp_name].part_of_speech
            samp_example = $db[samp_name].example
              @samp_area.clear do
                button(samp_name) do
                  @samp_source.text = samp_source
                  @samp_part_of_speech.text = samp_part_of_speech
                end
                para "Source:", :emphasis => "oblique"; @samp_source = para
                para "Part of speech:",
                :emphasis => "oblique"; @samp_part_of_speech = para

                button "Show target and example" do
                  @samp_target.text = samp_target
                  @samp_example.text = samp_example
                end
                  para "Target:", :emphasis => "oblique"; @samp_target = para
                  para "Example:", :emphasis => "oblique"; @samp_example = para
              end
          end
      end
    end
    @samp_area = stack{}
  end
######################
# Learning stack end #
######################

end
