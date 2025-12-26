#
# Copyright 2017 Agilx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"
require "fluent/plugin/filter_apptuit.rb"
require "test/plugin/java_fingerprint_tests.rb"
require "test/plugin/node_fingerprint_tests.rb"
require "test/plugin/python_fingerprint_tests.rb"
require "fluent/plugin/fingerprinter.rb"

class ApptuitFilterTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  def create_driver(config={})
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::ApptuitFilter).configure(config)
  end

  config = ""
  python_conf = %[
	lang python
  ]
  java_conf = %[
	lang java
  ]
  nodejs_conf = %[
	lang nodejs
  ]

  python_msg = 'Traceback (most recent call last):
File "./app.py", line 7, in <module>
  from schema import schema
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/schema.py", line 60, in <module>
  schema = graphene.Schema(query=Query, types=[Department, Employee, Role])
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py", line 62, in __init__
  self.build_typemap()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py", line 126, in build_typemap
  initial_types, auto_camelcase=self.auto_camelcase, schema=self
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 80, in __init__
  super(TypeMap, self).__init__(types)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 28, in __init__
  self.update(reduce(self.reducer, types, OrderedDict()))  # type: ignore
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 117, in graphene_reducer
  return GraphQLTypeMap.reducer(map, internal_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 106, in reducer
  field_map = type.fields
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py", line 22, in __get__
  value = obj.__dict__[self.func.__name__] = self.func(obj)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 221, in fields
  return define_field_map(self, self._fields)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 235, in define_field_map
  field_map = field_map()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 274, in construct_fields_for_type
  map = self.reducer(map, field.type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 117, in graphene_reducer
  return GraphQLTypeMap.reducer(map, internal_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 106, in reducer
  field_map = type.fields
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py", line 22, in __get__
  value = obj.__dict__[self.func.__name__] = self.func(obj)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 221, in fields
  return define_field_map(self, self._fields)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 235, in define_field_map
  field_map = field_map()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 274, in construct_fields_for_type
  map = self.reducer(map, field.type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 93, in graphene_reducer
  return self.reducer(map, type.of_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 93, in graphene_reducer
  return self.reducer(map, type.of_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 117, in graphene_reducer
  return GraphQLTypeMap.reducer(map, internal_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 106, in reducer
  field_map = type.fields
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py", line 22, in __get__
  value = obj.__dict__[self.func.__name__] = self.func(obj)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 221, in fields
  return define_field_map(self, self._fields)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 235, in define_field_map
  field_map = field_map()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 274, in construct_fields_for_type
  map = self.reducer(map, field.type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 117, in graphene_reducer
  return GraphQLTypeMap.reducer(map, internal_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 106, in reducer
  field_map = type.fields
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py", line 22, in __get__
  value = obj.__dict__[self.func.__name__] = self.func(obj)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 221, in fields
  return define_field_map(self, self._fields)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 235, in define_field_map
  field_map = field_map()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 274, in construct_fields_for_type
  map = self.reducer(map, field.type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 117, in graphene_reducer
  return GraphQLTypeMap.reducer(map, internal_type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py", line 106, in reducer
  field_map = type.fields
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py", line 22, in __get__
  value = obj.__dict__[self.func.__name__] = self.func(obj)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 221, in fields
  return define_field_map(self, self._fields)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py", line 235, in define_field_map
  field_map = field_map()
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 274, in construct_fields_for_type
  map = self.reducer(map, field.type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 88, in reducer
  return self.graphene_reducer(map, type)
File "/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py", line 99, in graphene_reducer
  ).format(_type.graphene_type, type)
AssertionError: Found different types with the same name in the schema: EmployeeConnection, EmployeeConnection'

python_sys_msg = "Traceback (most recent call last):#012File \"./app.py\", line 7, in <module>#012  from schema import schema#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/schema.py\", line 60, in <module>#012  schema = graphene.Schema(query=Query, types=[Department, Employee, Role])#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py\", line 62, in __init__#012  self.build_typemap()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py\", line 126, in build_typemap#012  initial_types, auto_camelcase=self.auto_camelcase, schema=self#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 80, in __init__#012  super(TypeMap, self).__init__(types)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 28, in __init__#012  self.update(reduce(self.reducer, types, OrderedDict()))  # type: ignore#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 93, in graphene_reducer#012  return self.reducer(map, type.of_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 93, in graphene_reducer#012  return self.reducer(map, type.of_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 99, in graphene_reducer#012  ).format(_type.graphene_type, type)#012AssertionError: Found different types with the same name in the schema: EmployeeConnection, EmployeeConnection"

python_error_msg = ":#012File \"./app.py\", line 7, in <module>#012  from schema import schema#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/schema.py\", line 60, in <module>#012  schema = graphene.Schema(query=Query, types=[Department, Employee, Role])#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py\", line 62, in __init__#012  self.build_typemap()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/schema.py\", line 126, in build_typemap#012  initial_types, auto_camelcase=self.auto_camelcase, schema=self#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 80, in __init__#012  super(TypeMap, self).__init__(types)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 28, in __init__#012  self.update(reduce(self.reducer, types, OrderedDict()))  # type: ignore#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 93, in graphene_reducer#012  return self.reducer(map, type.of_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 93, in graphene_reducer#012  return self.reducer(map, type.of_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 117, in graphene_reducer#012  return GraphQLTypeMap.reducer(map, internal_type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/typemap.py\", line 106, in reducer#012  field_map = type.fields#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/pyutils/cached_property.py\", line 22, in __get__#012  value = obj.__dict__[self.func.__name__] = self.func(obj)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 221, in fields#012  return define_field_map(self, self._fields)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphql/type/definition.py\", line 235, in define_field_map#012  field_map = field_map()#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 274, in construct_fields_for_type#012  map = self.reducer(map, field.type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 88, in reducer#012  return self.graphene_reducer(map, type)#012File \"/home/joseph/Documents/graphene-sqlalchemy/examples/flask_sqlalchemy/env/lib/python3.6/site-packages/graphene/types/typemap.py\", line 99, in graphene_reducer#012  ).format(_type.graphene_type, type)#012AssertionError: Found different types with the same name in the schema: EmployeeConnection, EmployeeConnection"
	
java_msg = 'SEVERE [http-nio-8080-exec-10] org.apache.catalina.core.StandardWrapperValve.invoke Servlet.service() for servlet [Testing] in context with path [/test] threw exception [GET method is not supported.] with root cause
 javax.servlet.ServletException: GET method is not supported.
	at TestingServlet.doGet(TestingServlet.java:18)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:634)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:199)
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:490)
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:668)
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:408)
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:834)
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1417)
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1135)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	at java.base/java.lang.Thread.run(Thread.java:844)'

java_sys_msg = 'SEVERE [http-nio-8080-exec-10] org.apache.catalina.core.StandardWrapperValve.invoke Servlet.service() for servlet [Testing] in context with path [/test] threw exception [GET method is not supported.] with root cause#012 javax.servlet.ServletException: GET method is not supported.#012#011at TestingServlet.doGet(TestingServlet.java:18)#012#011at javax.servlet.http.HttpServlet.service(HttpServlet.java:634)#012#011at javax.servlet.http.HttpServlet.service(HttpServlet.java:741)#012#011at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)#012#011at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)#012#011at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)#012#011at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)#012#011at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)#012#011at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:199)#012#011at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)#012#011at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:490)#012#011at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:139)#012#011at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)#012#011at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:668)#012#011at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)#012#011at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)#012#011at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:408)#012#011at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)#012#011at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:834)#012#011at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1417)#012#011at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)#012#011at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1135)#012#011at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)#012#011at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)#012#011at java.base/java.lang.Thread.run(Thread.java:844)'

nodejs_msg = 'Error: Something unexpected has occurred.
    at main (c:\Users\Me\Documents\MyApp\app.js:9:15)
    at Object. (c:\Users\Me\Documents\MyApp\app.js:17:1)
    at Module._compile (module.js:460:26)
    at Object.Module._extensions..js (module.js:478:10)
    at Module.load (module.js:355:32)
    at Function.Module._load (module.js:310:12)
    at Function.Module.runMain (module.js:501:10)
    at startup (node.js:129:16)
    at node.js:814:3'

nodejs_sys_msg = "Error: Something unexpected has occurred.#012    at main (c:\\Users\\Me\\Documents\\MyApp\\app.js:9:15)#012    at Object. (c:\\Users\\Me\\Documents\\MyApp\\app.js:17:1)#012    at Module._compile (module.js:460:26)#012    at Object.Module._extensions..js (module.js:478:10)#012    at Module.load (module.js:355:32)#012    at Function.Module._load (module.js:310:12)#012    at Function.Module.runMain (module.js:501:10)#012    at startup (node.js:129:16)#012    at node.js:814:3"

nodejs_error_msg = "Something unexpected has occurred.#012    at main (c:\\Users\\Me\\Documents\\MyApp\\app.js:9:15)#012    at Object. (c:\\Users\\Me\\Documents\\MyApp\\app.js:17:1)#012    at Module._compile (module.js:460:26)#012    at Object.Module._extensions..js (module.js:478:10)#012    at Module.load (module.js:355:32)#012    at Function.Module._load (module.js:310:12)#012    at Function.Module.runMain (module.js:501:10)#012    at startup (node.js:129:16)#012    at node.js:814:3"
	
	
  test "filter" do
    d = create_driver(python_conf)
    time = event_time
    d.run do
	d.feed("filter.python", time, {'message' => python_msg})
    end
    assert_equal('6c4a36dfca6b751f16a4065d61ec0de3f96e7eb8', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"syslog true")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'message' => python_sys_msg})
    end
    assert_equal('6c4a36dfca6b751f16a4065d61ec0de3f96e7eb8', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_msg})
    end
    assert_equal('6c4a36dfca6b751f16a4065d61ec0de3f96e7eb8', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"syslog true\n"+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_sys_msg})
    end
    assert_equal('6c4a36dfca6b751f16a4065d61ec0de3f96e7eb8', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_sys_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(config+"lang php")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_sys_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"syslog true"+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_error_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_error_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(python_conf+"syslog true\n"+"error_msg_tag error_message")
    time = event_time
    d.run do
        d.feed("filter.python",time, {'error_message' => python_error_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(java_conf)
    time = event_time
    d.run do
	d.feed("filter.java", time, {'message' => java_msg})
    end
    assert_equal('35005154c55de5f08021c04959646a00063a8a81', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(java_conf+"syslog true")
    time = event_time
    d.run do
	d.feed("filter.java", time, {'message' => java_sys_msg})
    end
    assert_equal('35005154c55de5f08021c04959646a00063a8a81', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(java_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.java", time, {'error_message' => java_msg})
    end
    assert_equal('35005154c55de5f08021c04959646a00063a8a81', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(java_conf+"syslog true\n"+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.java", time, {'error_message' => java_sys_msg})
    end
    assert_equal('35005154c55de5f08021c04959646a00063a8a81', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(java_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.java", time, {'error_message' => java_sys_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(config+"lang ruby")
    time = event_time
    d.run do
	d.feed("filter.java", time, {'error_message' => java_sys_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(nodejs_conf)
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'message' => nodejs_msg})
    end
    assert_equal('24f271892eeaac14506e7ab563da0f03a19b0d84', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(nodejs_conf+"syslog true")
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'message' => nodejs_sys_msg})
    end
    assert_equal('24f271892eeaac14506e7ab563da0f03a19b0d84', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(nodejs_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'error_message' => nodejs_msg})
    end
    assert_equal('24f271892eeaac14506e7ab563da0f03a19b0d84', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(nodejs_conf+"syslog true\n"+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'error_message' => nodejs_sys_msg})
    end
    assert_equal('24f271892eeaac14506e7ab563da0f03a19b0d84', d.filtered_records[0]['error_fingerprint'])
    d = create_driver(nodejs_conf+"error_msg_tag error_message")
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'error_message' => nodejs_error_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
    d = create_driver(config+"lang go")
    time = event_time
    d.run do
	d.feed("filter.nodejs", time, {'error_message' => nodejs_error_msg})
    end
    assert_equal(nil, d.filtered_records[0]['error_fingerprint'])
  end
  
  #Nodejs fingerprint tests
  testing_object = NodeFingerprintTests.new()
  fingerprint_object = FingerPrinter.new()

  testing_object.test_fp_not_a_stacktrace(fingerprint_object)
  testing_object.test_fp_basic(fingerprint_object)
  testing_object.test_fp_short(fingerprint_object)
  testing_object.test_fp_mulitline_message(fingerprint_object)
  testing_object.test_fp_json_wrapped(fingerprint_object)
  testing_object.test_fp_json_with_at(fingerprint_object)
  
  #Python fingerprint tests
  testing_object = PythonFingerprintTests.new()
  fingerprint_object = FingerPrinter.new()

  testing_object.test_fp_tmp(fingerprint_object)
  testing_object.test_fp_colon_in_code(fingerprint_object)
  testing_object.test_fp_colon_in_code1(fingerprint_object)
  testing_object.test_fp_one_err(fingerprint_object)
  testing_object.test_fp_multi_err(fingerprint_object)
  testing_object.test_fp_no_message(fingerprint_object)
  testing_object.test_fp_message_has_traceback(fingerprint_object)

  #Java fingerprint tests
  testing_object = JavaFingerprintTests.new()
  fingerprint_object = FingerPrinter.new()

  testing_object.test_baseline(fingerprint_object)
  testing_object.test_nested_basic(fingerprint_object)
  testing_object.test_fill_nostacktrace_nested_exception(fingerprint_object)
  testing_object.test_otsd_exception(fingerprint_object)
  testing_object.test_old_nesting_sax(fingerprint_object)
  testing_object.test_old_nesting_jaxb(fingerprint_object)
  testing_object.test_linenumbers_ignored(fingerprint_object)
  testing_object.test_circular_ref(fingerprint_object)
  testing_object.test_exception_in_dynamic_proxy(fingerprint_object)
  testing_object.test_reflection_inflation(fingerprint_object)
  testing_object.test_nested_non_nested(fingerprint_object)
  testing_object.test_multi_line_message(fingerprint_object)
  testing_object.test_heuristic_stacktrace_search(fingerprint_object)
end

