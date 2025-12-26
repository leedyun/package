module FortniteApi
    class CurrentSquad
        attr_reader :values
            
        def initialize(hash={})
            @values = hash
        end
        
        def custom
            self.values['curr_p9']
        end
        
        def trnrating
            self.values['curr_p9']['trnRating']
        end
        
        def score
            self.values['curr_p9']['score']
        end

        def scorepermatch
            self.values['curr_p9']['scorePerMatch']
        end        
        
        def top1
            self.values['curr_p9']['top1']
        end
        
        def top10
            self.values['curr_p9']['top10']
        end
        
        def top25
            self.values['curr_p9']['top25']
        end
        
        def winratio
            self.values['curr_p9']['winRatio']
        end        
        
        def kills
            self.values['curr_p9']['kills']
        end
        
        def kd
            self.values['curr_p9']['kd']
        end
        
        def kpg
            self.values['curr_p9']['kpg']
        end
    end
end