module FortniteApi
    class CurrentDuo
        attr_reader :values
            
        def initialize(hash={})
            @values = hash
        end
        
        def custom
            self.values['curr_p10']
        end
        
        def trnrating
            self.values['curr_p10']['trnRating']
        end
        
        def score
            self.values['curr_p10']['score']
        end

        def scorepermatch
            self.values['curr_p10']['scorePerMatch']
        end        
        
        def top1
            self.values['curr_p10']['top1']
        end
        
        def top10
            self.values['curr_p10']['top10']
        end
        
        def top25
            self.values['curr_p10']['top25']
        end
        
        def winratio
            self.values['curr_p10']['winRatio']
        end        
        
        def kills
            self.values['curr_p10']['kills']
        end
        
        def kd
            self.values['curr_p10']['kd']
        end
        
        def kpg
            self.values['curr_p10']['kpg']
        end
    end
end