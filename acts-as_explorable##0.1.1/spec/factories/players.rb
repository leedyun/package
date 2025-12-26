FactoryGirl.define do
  factory :player, aliases: [:zlatan, :god_of_football] do
    first_name 'Zlatan'
    last_name 'Ibrahimovic'
    position 'FW'
    city 'Paris'
    club 'PSG'

    factory :manuel, aliases: [:goalkeeper] do
      first_name 'Manuel'
      last_name 'Neuer'
      position 'GK'
      city 'München'
      club 'FC Bayern München'
    end

    factory :bastian, aliases: [:schweini] do
      first_name 'Bastian'
      last_name 'Schweinsteiger'
      position 'MF'
      city 'München'
      club 'FC Bayern München'
    end

    factory :sascha do
      first_name 'Sascha'
      last_name 'Mölders'
      position 'FW'
      city 'Augsburg'
      club 'FC Augsburg'
    end

    factory :christiano, aliases: [:forward] do
      first_name 'Christiano'
      last_name 'Ronaldo'
      position 'FW'
      city 'Madrid'
      club 'Real Madrid'
    end

    factory :toni do
      first_name 'Toni'
      last_name 'Kroos'
      position 'MF'
      city 'Madrid'
      club 'Real Madrid'
    end

    factory :fernando do
      first_name 'Fernando'
      last_name 'Torres'
      position 'FW'
      city 'Madrid'
      club 'Athletico Madrid'
    end
  end
end
