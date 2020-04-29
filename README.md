# crystal-oracle

Crystal driver for Oracle Databse

This is essentially a wrapper around [ODPI](https://github.com/oracle/odpi) similar to [cx_Oracle](https://github.com/oracle/python-cx_Oracle) for Python and [godror](https://github.com/godror/godror) for Go.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     oracle:
       github: sourgrasses/crystal-oracle
   ```

2. Run `shards install`

## Usage

```crystal
require "db"
require "oracle"

DB.open "oracle://user:password@host:port/SID" do |db|
  db.exec "drop table if exists goodfriends"
  db.exec "create table goodfriends (name varchar(30), age int)"
  db.exec "insert into goodfriends values (:1, :2)", "Ben Buddy", 28

  arg1 = "Sarah Bear"
  arg2 = 33
  db.exec "insert into contacts values (:1, :2)", arg1, arg2

  puts "max age:"
  puts db.scalar "select max(age) from contacts" # => 33

  puts "contacts:"
  db.query "select name, age from contacts order by age desc" do |res|
    puts "#{res.column_name(0)} (#{res.column_name(1)})"
    # => name (age)
    res.each do
      puts "#{res.read} (#{res.read})"
      # => Sarah Bear (33)
      # => Ben Buddy (28)
    end
  end
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/sourgrasses/crystal-oracle/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jenn Wheeler](https://github.com/sourgrasses) - creator and maintainer
