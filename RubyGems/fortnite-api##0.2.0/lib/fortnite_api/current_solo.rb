module FortniteApi
    class CurrentSolo
        attr_reader :values
            
        def initialize(hash={})
            @values = hash
        end
        
        def custom
            self.values['curr_p2']
        end
        
        def trnrating
            self.values['curr_p2']['trnRating']
        end
        
        def score
            self.values['curr_p2']['score']
        end

        def scorepermatch
            self.values['curr_p2']['scorePerMatch']
        end        
        
        def top1
            self.values['curr_p2']['top1']
        end
        
        def top10
            self.values['curr_p2']['top10']
        end
        
        def top25
            self.values['curr_p2']['top25']
        end
        
        def winratio
            self.values['curr_p2']['winRatio']
        end        
        
        def kills
            self.values['curr_p2']['kills']
        end
        
        def kd
            self.values['curr_p2']['kd']
        end
        
        def kpg
            self.values['curr_p2']['kpg']
        end
    end
end