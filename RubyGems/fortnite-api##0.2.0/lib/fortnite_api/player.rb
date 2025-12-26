module FortniteApi
    class Player
        attr_reader :epicuserhandle, :platformnamelong, :stats, :lifetimestats, :recentmatches
        
        def initialize(opts={})
            opts.each { |k,v| instance_variable_set("@#{k.downcase}", v) }
        end
        
        def globalsolo
            GlobalSolo.new(self.stats)
        end
        
        def globalduo
            GlobalDuo.new(self.stats)
        end
        
        def globalsquad
            GlobalSquad.new(self.stats)
        end
        
        def currentsolo
            CurrentSolo.new(self.stats)
        end
        
        def currentduo
            CurrentDuo.new(self.stats)
        end
        
        def currentsquad
            CurrentSquad.new(self.stats)
        end
    end
end