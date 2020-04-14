@[Link("odpic")]
lib ODPI
  type DpiConnCreateParams = Void
  type DpiCommonCreateParams = Void
  type DpiConn = Void
  type DpiContext = Void
  type DpiStmt = Void
  type UserName = UInt8*

  enum DpiAuthMode : UInt32
    Default = 0x00000000
    Sysdba  = 0x00000002
    Sysoper = 0x00000004
    Prelim  = 0x00000008
    Sysasm  = 0x00008000
    Sysbkp  = 0x00020000
    Sysdgd  = 0x00040000
    Syskmt  = 0x00080000
    Sysrac  = 0x00100000
  end

  enum DpiConnCloseMode : UInt32
    Default = 0x00
    Drop    = 0x01
    Retag   = 0x02
  end

  enum DpiCreateMode : UInt32
    Default     = 0x00
    Threaded    = 0x01
    Events      = 0x04
  end

  enum DpiDeqMode : UInt32
    Browse          = 1
    Locked          = 2
    Remove          = 3
    RemoveNoData    = 4
  end

  enum DpiDeqNavigation : UInt32
    FirstMsg        = 1
    NextTransaction = 2
    NextMsg         = 3
  end

  enum DpiEventType : UInt32
    None        = 0
    Startup     = 1
    Shutdown    = 2
    ShutdownAny = 3
    Dereg       = 5
    ObjChange   = 6
    QueryChange = 7
    Aq          = 100
  end

  enum DpiExecMode : UInt32
    Default             = 0x00000000
    DescribeOnly        = 0x00000010
    CommitOnSuccess     = 0x00000020
    BatchErrors         = 0x00000080
    ParseOnly           = 0x00000100
    ArrayDmlRowcounts   = 0x00100000
  end

  enum DpiFetchMode : UInt16
    Next        = 0x02
    First       = 0x04
    Last        = 0x08
    Prior       = 0x10
    Absolute    = 0x20
    Relative    = 0x40
  end

  enum DpiMessageDeliveryMode : UInt16
    MsgPersistent           = 1
    MsgBuffered             = 2
    MsgPersistentOrBuffered = 3
  end

  enum DpiMessageState : UInt32
    Ready       = 0
    Waiting     = 1
    Processed   = 2
    Expired     = 3
  end

  enum DpiNativeTypeNum : UInt32
    Int64       = 3000
    Uint64      = 3001
    Float       = 3002
    Double      = 3003
    Bytes       = 3004
    Timestamp   = 3005
    IntervalDs  = 3006
    IntervalYm  = 3007
    Lob         = 3008
    Object      = 3009
    Stmt        = 3010
    Boolean     = 3011
    Rowid       = 3012
  end

  enum DpiOpCode : UInt32
    AllOps  = 0x00
    AllRows = 0x01
    Insert  = 0x02
    Update  = 0x04
    Delete  = 0x08
    Alter   = 0x10
    Drop    = 0x20
    Unknown = 0x40
  end

  enum DpiOracleTypeNum : UInt32
    None            = 2000
    Varchar         = 2001
    Nvarchar        = 2002
    Char            = 2003
    Nchar           = 2004
    Rowid           = 2005
    Raw             = 2006
    NativeFloat     = 2007
    NativeDouble    = 2008
    NativeInt       = 2009
    Number          = 2010
    Date            = 2011
    Timestamp       = 2012
    TimestampTz     = 2013
    TimestampLtz    = 2014
    IntervalDs      = 2015
    IntervalYm      = 2016
    Clob            = 2017
    Nclob           = 2018
    Blob            = 2019
    Bfile           = 2020
    Stmt            = 2021
    Boolean         = 2022
    Object          = 2023
    LongVarchar     = 2024
    LongRaw         = 2025
    NativeUint      = 2026
    Max             = 2027
  end

  enum DpiPoolCloseMode : UInt32
    Default = 0x00
    Force   = 0x01
  end

  enum DpiPoolGetMode : UInt8
    Wait        = 0
    Nowait      = 1
    Forceget    = 2
    Timedwait   = 3
  end

  enum DpiPurity : UInt32
    Default = 0
    New     = 1
    Self    = 2
  end

  enum DpiShutdownMode : UInt32
    Default             = 0
    Transactional       = 1
    TransactionalLocal  = 2
    Immediate           = 3
    Abort               = 4
    Final               = 5
  end

  enum SodaFlags : UInt32
    Default         = 0x00
    AtomicCommit    = 0x01
    CreateCollMap   = 0x02
    IndexDropForce  = 0x04
  end

  enum DpiStartupMode : UInt32
    Default     = 0
    Force       = 1
    Restrict    = 2
  end

  enum DpiStatementType : UInt16
    Unknown     = 0
    Select      = 1
    Update      = 2
    Delete      = 3
    Insert      = 4
    Create      = 5
    Drop        = 6
    Alter       = 7
    Begin       = 8
    Declare     = 9
    Call        = 10
    ExplainPlan = 15
    Merge       = 16
    Rollback    = 17
    Commit      = 21
  end

  enum DpiSubscrGroupingClass : UInt8
    Time    = 1
  end

  enum DpiSubscrGroupingType : UInt8
    Summary = 1
    Last    = 2
  end

  enum DpiSubscrNamespace : UInt32
    Aq          = 1
    Dbchange    = 2
  end

  enum DpiSubscrProtocol : UInt32
    Callback    = 0
    Mail        = 1
    Plsql       = 2
    Http        = 3
  end

  enum DpiSubscrQos : UInt32
    Reliable    = 0x01
    DeregNfy    = 0x02
    Rowids      = 0x04
    Query       = 0x08
    BestEffort  = 0x10
  end

  enum DpiVisibility : UInt32
    Immediate   = 1
  end

  struct DpiErrorInfo
    code : Int32
    offset : UInt16
    message : UInt8*
    messageLength : UInt32
    encoding : UInt8*
    fnName : UInt8*
    action : UInt8*
    sqlState : UInt8*
    isRecoverable : Int32
  end

  fun dpi_conn_create = dpiConn_create(context : DpiContext*,
                                       user_name : UserName*,
                                       user_name_length : UInt32,
                                       password : UInt8*,
                                       password_length : UInt32,
                                       connect_string : UInt8*,
                                       connect_string_length : UInt32,
                                       common_params : DpiCommonCreateParams*,
                                       createParams : DpiConnCreateParams*,
                                       conn : DpiConn**) : Int32

  fun dpi_conn_release = dpiConn_release(conn : DpiConn*) : Int32

  fun dpi_conn_close = dpiConn_close(conn : DpiConn*,
                                     mode : DpiConnCloseMode,
                                     tag : UInt8*,
                                     tag_length : UInt32) : Int32

  fun dpi_context_create = dpiContext_create(majorVersion : UInt32,
                                             minorVersion : UInt32,
                                             context : DpiContext**,
                                             errorInfo : DpiErrorInfo*) : Int32

  fun dpi_context_destroy = dpiContext_destroy(context : DpiContext*) : Int32

  fun dpi_context_get_error = dpiContext_getError(context : DpiContext*,
                                                  errorInfo : DpiErrorInfo*) : Void

  fun dpi_conn_prepare_stmt = dpiConn_prepareStmt(conn : DpiConn*,
                                                  scrollable : Int32,
                                                  sql : UInt8*,
                                                  sqlLength : UInt32,
                                                  tag : UInt8*,
                                                  tagLength : UInt32,
                                                  stmt : DpiStmt**) : Int32

  fun dpi_stmt_execute = dpiStmt_execute(stmt : DpiStmt*,
                                         mode : DpiExecMode,
                                         numQueryColumns : UInt32*) : Int32

  fun dpi_stmt_execute_many = dpiStmt_executeMany(stmt : DpiStmt*,
                                                  mode : DpiExecMode,
                                                  numIters : UInt32)

  fun dpi_stmt_fetch = dpiStmt_fetch(stmt : DpiStmt*,
                                     found : Int32*,
                                     bufferRowIndex : UInt32*) : Int32

  fun dpi_stmt_fetch_rows = dpiStmt_fetchRows(stmt : DpiStmt*,
                                              maxRows : UInt32,
                                              bufferRowIndex : UInt32*,
                                              numRowsFetched : UInt32*,
                                              moreRows : Int32*) : Int32

  fun dpi_stmt_release = dpiStmt_release(stmt : DpiStmt*)
end
