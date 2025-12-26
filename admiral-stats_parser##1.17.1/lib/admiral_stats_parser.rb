require 'time'
require 'admiral_stats_parser/version'
require 'admiral_stats_parser/parser/personal_basic_info_parser'
require 'admiral_stats_parser/parser/area_capture_info_parser'
require 'admiral_stats_parser/parser/tc_book_info_parser'
require 'admiral_stats_parser/parser/equip_book_info_parser'
require 'admiral_stats_parser/parser/character_list_info_parser'
require 'admiral_stats_parser/parser/equip_list_info_parser'
require 'admiral_stats_parser/parser/event_info_parser'
require 'admiral_stats_parser/parser/blueprint_list_info_parser'
require 'admiral_stats_parser/parser/cop_info_parser'

module AdmiralStatsParser
  # 最新の API バージョンを返します。
  def self.get_latest_api_version
    return 17
  end

  # エクスポート時刻を元に、API バージョンを推測して返します。
  def self.guess_api_version(exported_at)
    # version 2 の開始日
    return 1 if exported_at < Time.parse('2016-06-30T07:00:00+0900')

    # version 3 の開始日
    return 2 if exported_at < Time.parse('2016-09-15T07:00:00+0900')

    # version 4 の開始日
    return 3 if exported_at < Time.parse('2016-10-27T07:00:00+0900')

    # version 5 の開始日
    return 4 if exported_at < Time.parse('2016-12-21T07:00:00+0900')

    # version 6 の開始日
    return 5 if exported_at < Time.parse('2017-02-14T07:00:00+0900')

    # version 7 の開始日
    return 6 if exported_at < Time.parse('2017-04-26T07:00:00+0900')

    # version 8 の開始日
    return 7 if exported_at < Time.parse('2017-06-01T07:00:00+0900')

    # version 9 の開始日
    return 8 if exported_at < Time.parse('2017-07-31T07:00:00+0900')

    # version 10 の開始日
    return 9 if exported_at < Time.parse('2017-09-21T07:00:00+0900')

    # version 11 の開始日
    return 10 if exported_at < Time.parse('2018-02-01T07:00:00+0900')

    # version 12 の開始日
    return 11 if exported_at < Time.parse('2018-02-16T07:00:00+0900')

    # version 13 の開始日
    return 12 if exported_at < Time.parse('2018-04-19T07:00:00+0900')

    # version 14 の開始日
    return 13 if exported_at < Time.parse('2018-05-14T07:00:00+0900')

    # version 15 の開始日
    return 14 if exported_at < Time.parse('2018-07-24T07:00:00+0900')

    # version 16 の開始日
    return 15 if exported_at < Time.parse('2019-05-09T07:00:00+0900')

    # version 17 の開始日
    return 16 if exported_at < Time.parse('2019-07-04T07:00:00+0900')

    return self.get_latest_api_version
  end

  # 基本情報をパースします。
  def self.parse_personal_basic_info(json, api_version)
    case api_version
      when 1
        PersonalBasicInfoParser.parse(json, 1)
      when 2..6
        PersonalBasicInfoParser.parse(json, 2)
      when 7..17
        PersonalBasicInfoParser.parse(json, 3)
      else
        raise 'unsupported API version'
    end
  end

  # 海域情報をパースします。
  def self.parse_area_capture_info(json, api_version)
    case api_version
      when 1
        AreaCaptureInfoParser.parse(json, 1)
      when 2..6
        AreaCaptureInfoParser.parse(json, 2)
      when 7..10
        AreaCaptureInfoParser.parse(json, 3)
      when 11..17
        AreaCaptureInfoParser.parse(json, 4)
      else
        raise 'unsupported API version'
    end
  end

  # 艦娘図鑑をパースします。
  def self.parse_tc_book_info(json, api_version)
    case api_version
      when 1
        TcBookInfoParser.parse(json, 1)
      when 2..11
        TcBookInfoParser.parse(json, 2)
      when 12..13
        TcBookInfoParser.parse(json, 3)
      when 14..16
        TcBookInfoParser.parse(json, 4)
      when 17
        TcBookInfoParser.parse(json, 5)
      else
        raise 'unsupported API version'
    end
  end

  # 装備図鑑をパースします。
  def self.parse_equip_book_info(json, api_version)
    case api_version
      when 1..17
        EquipBookInfoParser.parse(json)
      else
        raise 'unsupported API version'
    end
  end

  # 艦娘一覧をパースします。
  def self.parse_character_list_info(json, api_version)
    case api_version
      when 1
        raise 'API version 1 does not support character list info'
      when 2
        CharacterListInfoParser.parse(json, 1)
      when 3..4
        CharacterListInfoParser.parse(json, 2)
      when 5..6
        CharacterListInfoParser.parse(json, 3)
      when 7..11
        CharacterListInfoParser.parse(json, 4)
      when 12..13
        CharacterListInfoParser.parse(json, 5)
      when 14..17
        CharacterListInfoParser.parse(json, 6)
      else
        raise 'unsupported API version'
    end
  end

  # 装備一覧をパースします。
  def self.parse_equip_list_info(json, api_version)
    case api_version
      when 1
        raise 'API version 1 does not support equip list info'
      when 2..8
        EquipListInfoParser.parse(json, 1)
      when 9..17
        EquipListInfoParser.parse(json, 2)
      else
        raise 'unsupported API version'
    end
  end

  # 装備一覧をパースして、最大装備保有数のみを取得します。
  def self.parse_max_slot_num(json, api_version)
    case api_version
      when 1..8
        EquipListInfoParser.parse_max_slot_num(json, 1)
      when 9..17
        EquipListInfoParser.parse_max_slot_num(json, 2)
      else
        raise 'unsupported API version'
    end
  end

  # イベント海域情報をパースします。
  def self.parse_event_info(json, api_version)
    case api_version
      when 1..3
        raise "API version #{api_version} does not support event info"
      when 4..6
        EventInfoParser.parse(json, 1)
      when 7..12
        EventInfoParser.parse(json, 2)
      when 13..17
        EventInfoParser.parse(json, 3)
      else
        raise 'unsupported API version'
    end
  end

  # イベント海域情報のサマリを作成します。
  def self.summarize_event_info(event_info_list, level, period, api_version)
    case api_version
      when 1..3
        raise "API version #{api_version} does not support event info"
      when 4..17
        {
            opened: EventInfoParser.opened?(event_info_list, level, period),
            all_cleared: EventInfoParser.all_cleared?(event_info_list, level, period),
            current_loop_counts: EventInfoParser.current_loop_counts(event_info_list, level, period),
            cleared_loop_counts: EventInfoParser.cleared_loop_counts(event_info_list, level, period),
            cleared_stage_no: EventInfoParser.cleared_stage_no(event_info_list, level, period),
            current_military_gauge_left: EventInfoParser.current_military_gauge_left(event_info_list, level, period)
        }
      else
        raise 'unsupported API version'
    end
  end

  # 改装設計図一覧をパースします。
  def self.parse_blueprint_list_info(json, api_version)
    case api_version
      when 1..6
        raise "API version #{api_version} does not support blueprint list info"
      when 7
        BlueprintListInfoParser.parse(json, 1)
      when 8..17
        BlueprintListInfoParser.parse(json, 2)
      else
        raise 'unsupported API version'
    end
  end

  # 輸送イベント海域情報をパースします。
  def self.parse_cop_info(json, api_version)
    case api_version
      when 1..14
        raise "API version #{api_version} does not support cop info"
      when 15..17
        CopInfoParser.parse(json, 1)
      else
        raise 'unsupported API version'
    end
  end
end
