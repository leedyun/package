module NewDB

  class Db
    attr_accessor :name
      def initialize(name)
        @name = name
      end
  end


  def create_new_db(new_db, store_for_all_dbs)
    database = Db.new(new_db)
    store_for_all_dbs.transaction do
      store_for_all_dbs[database.name] = database
    end
    
  end

end
