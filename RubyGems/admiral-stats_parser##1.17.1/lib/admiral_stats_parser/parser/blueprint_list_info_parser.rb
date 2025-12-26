require 'json'
require 'admiral_stats_parser/model/blueprint_list_info'

class BlueprintListInfoParser
  MANDATORY_KEYS = {
      1 => {
          ship_class_id: Integer,
          ship_class_index: Integer,
          ship_sort_no: Integer,
          ship_type: String,
          ship_name: String,
          status_img: String,
          blueprint_total_num: Integer,
          expiration_date_list: :expiration_date_list,
      },
      2 => {
          ship_class_id: Integer,
          ship_class_index: Integer,
          ship_sort_no: Integer,
          ship_type: String,
          ship_name: String,
          status_img: String,
          blueprint_total_num: Integer,
          exists_warning_for_expiration: :boolean,
          expiration_date_list: :expiration_date_list,
      }
  }

  EXPIRATION_DATE_MANDATORY_KEYS = {
      1 => {
          expiration_date: Integer,
          blueprint_num: Integer,
      },
      2 => {
          expiration_date: Integer,
          blueprint_num: Integer,
          expire_this_month: :boolean,
      }
  }

  def self.parse(json, api_version)
    items_array = JSON.parse(json)

    unless items_array.is_a?(Array)
      raise 'json is not an Array'
    end

    results = []
    items_array.each do |items|
      result = BlueprintListInfo.new

      MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless items.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 有効期限の情報を格納するために、特別な処理を追加
        if key_class == :expiration_date_list
          result.instance_variable_set(
              "@#{key.to_s}", BlueprintListInfoParser.parse_expiration_date_list(items[camel_case_key], api_version))
          next
        end

        # 結果のクラスが合わなければエラー
        # ruby には Boolean クラスがないので、そこだけ特別な処理を用意する
        if key_class == :boolean
          unless [true, false].include?(items[camel_case_key])
            raise "Mandatory key #{key} is not boolean"
          end
        else
          unless items[camel_case_key].is_a?(key_class)
            raise "Mandatory key #{key} is not class #{key_class}"
          end
        end

        result.instance_variable_set("@#{key.to_s}", items[camel_case_key])
      end

      results << result
    end

    results
  end

  def self.parse_expiration_date_list(expiration_date_list, api_version)
    results = []

    expiration_date_list.each do |ed|
      result = BlueprintListInfo::ExpirationDate.new

      EXPIRATION_DATE_MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless ed.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
        # ruby には Boolean クラスがないので、そこだけ特別な処理を用意する
        if key_class == :boolean
          unless [true, false].include?(ed[camel_case_key])
            raise "Mandatory key #{key} is not boolean"
          end
        else
          unless ed[camel_case_key].is_a?(key_class)
            raise "Mandatory key #{key} is not class #{key_class}"
          end
        end

        result.instance_variable_set("@#{key.to_s}", ed[camel_case_key])
      end

      results << result
    end

    results
  end
end
