class Oracle::Driver < DB::Driver
  def build_connection(context : DB::ConnectionContext) : Connection
    Oracle::Connection.new(context)
  end
end

DB.register_driver "oracle", Oracle::Driver
