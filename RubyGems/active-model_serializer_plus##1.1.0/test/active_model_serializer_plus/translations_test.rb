require '../test_helper'
require 'active_model_serializer_plus'

class ParsingClass
    attr_accessor :x
end

class BuilderClass
    attr_accessor :a
    attr_accessor :b
end

class BuilderSubClass < BuilderClass
end

class TranslationsTest < ActiveSupport::TestCase

    def setup
        @date_today = Date.today
        @datetime_now = DateTime.now
        @time_now = Time.now

        @format_parse = ParsingClass.new
        @format_parse.x = 'xyzzy'
        @build = BuilderClass.new
        @build.a = 'attr x'
        @build.b = 17
    end

    test 'type name translation' do
        r_true = ActiveModelSerializerPlus.type_name_xlate('TrueClass')
        assert_equal 'Boolean', r_true, 'translate TrueClass'
        r_false = ActiveModelSerializerPlus.type_name_xlate('FalseClass')
        assert_equal 'Boolean', r_false, 'translate FalseClass'
        r_hash = ActiveModelSerializerPlus.type_name_xlate('Hash')
        assert_equal 'Container', r_hash, 'translate Hash'
        r_array = ActiveModelSerializerPlus.type_name_xlate('Array')
        assert_equal 'Container', r_array, 'translate Array'
    end

    test 'format value' do
        assert_equal @date_today.xmlschema, ActiveModelSerializerPlus.format(@date_today), 'format date'
        assert_equal @datetime_now.xmlschema, ActiveModelSerializerPlus.format(@datetime_now), 'format datetime'
        assert_equal @time_now.xmlschema, ActiveModelSerializerPlus.format(@time_now), 'format time'
        assert_equal '5', ActiveModelSerializerPlus.format(5), 'format integer'
        assert_equal 'xyzzy', ActiveModelSerializerPlus.format('xyzzy'), 'format string'
        assert_equal 'true', ActiveModelSerializerPlus.format(true), 'format true'
        assert_equal 'false', ActiveModelSerializerPlus.format(false), 'format false'
        assert_equal '7.14', ActiveModelSerializerPlus.format(7.14), 'format float'
    end

    test 'parse strings' do
        v = ActiveModelSerializerPlus.parse('Symbol', 'xyzzy')
        assert_not_nil v, 'Symbol from string'
        assert_kind_of Symbol, v, 'Symbol from string'
        assert_equal :xyzzy, v, 'Symbol from string'
        v = ActiveModelSerializerPlus.parse('Symbol', 5)
        assert_not_nil v, 'Symbol from integer'
        assert_kind_of Symbol, v, 'Symbol from integer'
        assert_equal :'5', v, 'Symbol from integer'
        v = ActiveModelSerializerPlus.parse('Symbol', [5, 4, 8])
        assert_not_nil v, 'Symbol from array'
        assert_kind_of Symbol, v, 'Symbol from array'
        assert_equal :'[5, 4, 8]', v, 'Symbol from array'

        v = ActiveModelSerializerPlus.parse('Time', @time_now.xmlschema)
        assert_not_nil v, 'Time from xmlschema'
        assert_kind_of Time, v, 'Time from xmlschema'
        assert_equal @time_now.utc.to_s, v.to_s, 'Time from xmlschema'
        v = ActiveModelSerializerPlus.parse('Time', @time_now.to_s)
        assert_not_nil v, 'Time from to_s'
        assert_kind_of Time, v, 'Time from to_s'
        assert_equal @time_now.to_s, v.to_s, 'Time from to_s'

        v = ActiveModelSerializerPlus.parse('Date', @date_today.xmlschema)
        assert_not_nil v, 'Date from xmlschema'
        assert_kind_of Date, v, 'Date from xmlschema'
        assert_equal @date_today.to_s, v.to_s, 'Date from xmlschema'
        v = ActiveModelSerializerPlus.parse('Date', @date_today.to_s)
        assert_not_nil v, 'Date from to_s'
        assert_kind_of Date, v, 'Date from to_s'
        assert_equal @date_today.to_s, v.to_s, 'Date from to_s'

        v = ActiveModelSerializerPlus.parse('DateTime', @datetime_now.xmlschema)
        assert_not_nil v, 'DateTime from xmlschema'
        assert_kind_of DateTime, v, 'DateTime from xmlschema'
        assert_equal @datetime_now.to_s, v.to_s, 'DateTime from xmlschema'
        v = ActiveModelSerializerPlus.parse('DateTime', @datetime_now.to_s)
        assert_not_nil v, 'DateTime from to_s'
        assert_kind_of DateTime, v, 'DateTime from to_s'
        assert_equal @datetime_now.to_s, v.to_s, 'DateTime from to_s'

        v = ActiveModelSerializerPlus.parse('Integer', '5')
        assert_not_nil v, 'Integer from integer'
        assert_kind_of Integer, v, 'Integer from integer'
        assert_equal 5, v, 'Integer from integer'

        v = ActiveModelSerializerPlus.parse('Float', '7.43')
        assert_not_nil v, 'Float from float'
        assert_kind_of Float, v, 'Float from float'
        assert_equal 7.43, v, 'Float from float'

        v = ActiveModelSerializerPlus.parse('BigDecimal', '89.461')
        assert_not_nil v, 'BigDecimal from decimal'
        assert_kind_of BigDecimal, v, 'BigDecimal from decimal'
        assert_equal 89.461, v, 'BigDecimal from decimal'

        v = ActiveModelSerializerPlus.parse('Boolean', 'true')
        assert_not_nil v, 'Boolean from true'
        assert_kind_of TrueClass, v, 'Boolean from true'
        assert v, 'Boolean from true'
        v = ActiveModelSerializerPlus.parse('Boolean', '1')
        assert_not_nil v, 'Boolean from 1'
        assert_kind_of TrueClass, v, 'Boolean from 1'
        assert v, 'Boolean from 1'
        v = ActiveModelSerializerPlus.parse('Boolean', 'false')
        assert_not_nil v, 'Boolean from false'
        assert_kind_of FalseClass, v, 'Boolean from false'
        assert_not v, 'Boolean from false'
        v = ActiveModelSerializerPlus.parse('Boolean', '0')
        assert_not_nil v, 'Boolean from 0'
        assert_kind_of FalseClass, v, 'Boolean from 0'
        assert_not v, 'Boolean from 0'
        v = ActiveModelSerializerPlus.parse('Boolean', 'few')
        assert_not_nil v, 'Boolean from invalid string'
        assert_kind_of FalseClass, v, 'Boolean from invalid string'
        assert_not v, 'Boolean from invalid string'

        v = ActiveModelSerializerPlus.parse('String', 'xyzzy')
        assert_nil v, 'String'

        v = ActiveModelSerializerPlus.parse('IPAddr', '192.168.9.25')
        assert_nil v, 'IPAddr'

        v = ActiveModelSerializerPlus.parse('Fixnum', '5')
        assert_not_nil v, 'Fixnum from integer'
        assert_kind_of Integer, v, 'Fixnum from integer'
        assert_equal 5, v, 'Fixnum from integer'
    end

    test 'build from hash' do
        v = IPAddr.new('192.168.23.94/24')
        j = v.to_json
        h = JSON.parse(j)
        r = ActiveModelSerializerPlus.build('IPAddr', h)
        assert_not_nil r, 'build IPAddr'
        assert_kind_of IPAddr, r, 'build IPAddr'
        assert_equal v, r, 'build IPAddr'

        r = ActiveModelSerializerPlus.build('Integer', { 'value' => 5 })
        assert_nil r, 'build integer'
    end

    test 'add types' do
        ActiveModelSerializerPlus.add_xlate( 'Xyzzy1', 'Xyzzy')
        r = ActiveModelSerializerPlus.type_name_xlate('Xyzzy1')
        assert_not_nil r, 'add type, translate type name, found'
        assert_kind_of String, r, 'add type, translate type name, found'
        assert_equal 'Xyzzy', r, 'add type, translate type name, found'
        r = ActiveModelSerializerPlus.type_name_xlate('Xyzzy')
        assert_nil r, 'add type, translate type name, not found'

        fmt_proc = Proc.new { |p| p.x.to_s }
        prs_proc = Proc.new { |s|
            p = ParsingClass.new
            p.x = s
            p
        }
        ActiveModelSerializerPlus.add_type('ParsingClass', fmt_proc, prs_proc, nil)
        v = ActiveModelSerializerPlus.format(@format_parse)
        assert_not_nil v, 'add type, format'
        assert_kind_of String, v, 'add type, format'
        assert_equal 'xyzzy', v, 'add type, format'
        v = ActiveModelSerializerPlus.parse('ParsingClass', 'jklmn')
        assert_not_nil v, 'add type, parse'
        assert_kind_of ParsingClass, v, 'add type, parse'
        assert_equal 'jklmn', v.x, 'add type, parse'
        v = ActiveModelSerializerPlus.parse('UnknownClass', 'abcde')
        assert_nil v, 'add type, parse, not found'

        bld_proc = Proc.new { |h|
            b = BuilderClass.new
            b.a = h['a']
            b.b = h['b'].to_i
            b
        }
        ActiveModelSerializerPlus.add_type('BuilderClass', nil, nil, bld_proc)
        v = ActiveModelSerializerPlus.build('BuilderClass', { 'a' => 'abcde', 'b' => 17 })
        assert_not_nil v, 'add type, build'
        assert_kind_of BuilderClass, v, 'add type, build'
        assert_not_nil v.a, 'add type, build'
        assert_equal 'abcde', v.a, 'add type, build'
        assert_not_nil v.b, 'add type, build'
        assert_equal 17, v.b, 'add type, build'
        v = ActiveModelSerializerPlus.build('UnknownClass', { 'a' => 'xyzzy', 'b' => 24 })
        assert_nil v, 'add type, build, not found'

        v = ActiveModelSerializerPlus.build('BuilderSubClass', { 'a' => 'abcde', 'b' => 17 })
        assert_nil v, 'add type, build subclass'
    end

    test 'convert to class' do
        r = ActiveModelSerializerPlus.to_class('Fixnum')
        assert_not_nil r, 'convert to class, string'
        assert_kind_of Class, r, 'convert to class, string'
        assert_equal 'Fixnum', r.name, 'convert to class, string'

        r = ActiveModelSerializerPlus.to_class(:Float)
        assert_not_nil r, 'convert to class, symbol'
        assert_kind_of Class, r, 'convert to class, symbol'
        assert_equal 'Float', r.name, 'convert to class, symbol'

        r = ActiveModelSerializerPlus.to_class(Hash)
        assert_not_nil r, 'convert to class, class'
        assert_kind_of Class, r, 'convert to class, class'
        assert_equal 'Hash', r.name, 'convert to class, class'

        assert_raise ArgumentError, 'convert to class, string, invalid' do
            r = ActiveModelSerializerPlus.to_class('Garbage')
        end

        assert_raise ArgumentError, 'convert to class, symbol, invalid' do
            r = ActiveModelSerializerPlus.to_class(:Garbage)
        end

        assert_raise NameError, 'convert to class, class, invalid' do
            r = ActiveModelSerializerPlus.to_class(Garbage)
        end

        assert_raise ArgumentError, 'convert to class, integer' do
            r = ActiveModelSerializerPlus.to_class(5)
        end
    end

    test 'convert to class name' do
        r = ActiveModelSerializerPlus.to_classname('Fixnum')
        assert_not_nil r, 'convert to class name, string'
        assert_kind_of String, r, 'convert to class name, string'
        assert_equal 'Fixnum', r, 'convert to class name, string'

        r = ActiveModelSerializerPlus.to_classname(:Float)
        assert_not_nil r, 'convert to class name, symbol'
        assert_kind_of String, r, 'convert to class name, symbol'
        assert_equal 'Float', r, 'convert to class name, symbol'

        r = ActiveModelSerializerPlus.to_classname(Hash)
        assert_not_nil r, 'convert to class name, class'
        assert_kind_of String, r, 'convert to class name, class'
        assert_equal 'Hash', r, 'convert to class name, class'

        assert_raise ArgumentError, 'convert to class name, invalid' do
            r = ActiveModelSerializerPlus.to_classname(17)
        end

        assert_raise NameError, 'convert to class name, bad class' do
            r = ActiveModelSerializerPlus.to_classname(Garbage)
        end
    end

end
