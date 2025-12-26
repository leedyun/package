module FortniteApi
    class GlobalSolo
        attr_reader :values
            
        def initialize(hash={})
            @values = hash
        end
        
        def custom
            self.values['p2']
        end
        
        def trnrating
            self.values['p2']['trnRating']
        end
        
        def score
            self.values['p2']['score']
        end

        def scorepermatch
            self.values['p2']['scorePerMatch']
        end        
        
        def top1
            self.values['p2']['top1']
        end
        
        def top10
            self.values['p2']['top10']
        end
        
        def top25
            self.values['p2']['top25']
        end
        
        def winratio
            self.values['p2']['winRatio']
        end        
        
        def kills
            self.values['p2']['kills']
        end
        
        def kd
            self.values['p2']['kd']
        end
        
        def kpg
            self.values['p2']['kpg']
        end
    end
end