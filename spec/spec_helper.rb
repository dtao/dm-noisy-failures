require "data_mapper"

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")

class Person
  include DataMapper::Resource
  has n, :memberships
  property :id,    Serial
  property :name,  String, :required => true
end

class Membership
  include DataMapper::Resource
  belongs_to :person
  property :id,        Serial
  property :person_id, Integer
  property :type,      String, :required => true
end

DataMapper.setup(:default, "sqlite3://" + File.join(File.dirname(__FILE__), "test.db"))
DataMapper.finalize
DataMapper.auto_migrate!
