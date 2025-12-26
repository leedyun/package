module FortniteApi
    class GlobalSquad
        attr_reader :values
            
        def initialize(hash={})
            @values = hash
        end
     
        def custom
            self.values['p9']
        end
        
        def trnrating
            self.values['p9']['trnRating']
        end
        
        def score
            self.values['p9']['score']
        end

        def scorepermatch
            self.values['p9']['scorePerMatch']
        end        
        
        def top1
            self.values['p9']['top1']
        end
        
        def top10
            self.values['p9']['top10']
        end
        
        def top25
            self.values['p9']['top25']
        end
        
        def winratio
            self.values['p9']['winRatio']
        end        
        
        def kills
            self.values['p9']['kills']
        end
        
        def kd
            self.values['p9']['kd']
        end
        
        def kpg
            self.values['p9']['kpg']
        end
    end
end