namespace java com.datnh.lib

// Unit for monitor
enum TStatsUnit {
	DAY = 0,
	HOUR = 1,
	WEEK = 2,
	MONTH = 3,
	REALTIME = 4,
	DAY_A7 = 5,
	DAY_A10 = 6,
	DAY_A30 = 7
}

struct TStatsTimestamp {
	1: TStatsUnit unit,
	2: i64 timestamp
}

// Struct for ranking
// for 1 item
struct TRankingItem {
	1: string key,
	2: i64 count,
	3: i32 order,
	4: string nextKey
}

// Struct for ranking table
// for items
struct TRankingTable {
	1: i64 id
	2: list<TRankingItem> items
	3: optional map<string, TRankingItem> mapItems
}

// Configuration of a service Thrift
struct TServiceConfig {
	1: required string category,
	2: required string name,
	3: required string host,
	4: required i32 port,
	5: optional string altHost, // secondary host
	6: optional i32 altPort, // secondary host port
	7: required i64 timeout, // read timeout for service,depends data-size
	8: required i64 connectTimeout, // connect timeout
	9: required bool framed, // server has FramedTransport? (default: true)
	10: required i32 maxConn,
	11: required i32 initConn,
	12: optional i64 lastUpdated, // last update config
	13: required i16 maxRetry,
	14: required i32 maxWait,
}

enum TMonitorValueType {
	BYTE = 1,
	SHORT = 2,
	INT = 3,
	LONG = 4,
	BOOL = 5,
	DOUBLE = 6,
	STRING = 7,
	NULL = 8
}

struct TMonitorValue {
	1: required TMonitorValueType type,
	2: optional byte byteVal,
	3: optional i16 shortVal,
	4: optional i32 intVal,
	5: optional i64 longVal,
	6: optional bool boolVal,
	7: optional double doubleVal,
	8: optional string stringVal
}

// Values' monitor
struct TGeneralMonitorValues {
	// Value's cpu 0 ~ 1 (0% ~ 100%)
	1: double cpuLoad,
	// Ram (bytes)
	2: i64 usedMemory,
	// Total thread of VM
	3: i32 threadCount,
	// total jobs are created/ 1 second
	4: i32 jobRequestRate,
	// how many job is done per last 1 second
	5: i32 jobServedRate,
}

// Struct for thread
struct TThreadInfo {
	1: i64 threadId,
	2: string threadName,
	3: double cpuLoad,
	4: list<string> stackTrace
}


// Service  monitor  process
service TCSMMonitorService {
	// get general values
	TGeneralMonitorValues getGeneralValues(),
	//get list Threads (ID) và name
	map<i64, string> getThreads(),
	// list information a thread
	TThreadInfo getThreadInfo(1: i64 threadId),

	// getting list monitor are sorted by category (set)
	map<string, set<string>> getCustomMonitors(),
	// get some or all values of a montior
	map<string, TMonitorValue> getMonitorValues(1: string category, 2: string monitorName, 3: set<string> properties),
	// get a field of a monitor
	TMonitorValue getMonitorValue(1: string category, 2: string monitorName, 3: string field),
	//release memory -- garbage collect
	void performGC(),
}

service TCSMService {
	string getServiceName(),
	string getServiceVersion(),
	i64 ping()
}