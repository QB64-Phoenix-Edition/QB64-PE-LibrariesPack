'-----------------------------------------------------------------------------------------------------------------------
' Data Structures test suite
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

DEFLNG A-Z
OPTION _EXPLICIT
$CONSOLE:ONLY

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/Catch'

$USELIBRARY:'a740g/QBDS-Array'
$USELIBRARY:'a740g/QBDS-HMap'
$USELIBRARY:'a740g/QBDS-HMap64'
$USELIBRARY:'a740g/QBDS-HSet'
$USELIBRARY:'a740g/QBDS-LList'
$USELIBRARY:'a740g/QBDS-Queue'
$USELIBRARY:'a740g/QBDS-Stack'

'-----------------------------------------------------------------------------------------------------------------------

TEST_ENABLE_ERROR_HANDLER

TEST_ENABLE_COLOR _FALSE
TEST_ENABLE_EXIT_ON_END _FALSE

TEST_BEGIN_ALL

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Initialization"

REDIM ht(0) AS HMap

HMap_Initialize ht()
TEST_CHECK HMap_GetCount(ht()) = 0, "Initial count should be 0"
TEST_CHECK_FALSE HMap_Contains(ht(), "nonexistent"), "Nonexistent key should not exist"
TEST_CHECK HMap_GetString(ht(), "nonexistent") = "", "Getting nonexistent key should return empty string"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Basic Integer Operations"

HMap_SetInteger ht(), "test", 42
TEST_CHECK HMap_GetInteger(ht(), "test") = 42, "Integer value should be 42"
TEST_CHECK HMap_GetEntryDataType(ht(), "test") = QBDS_TYPE_INTEGER, "Data type should be INT"
TEST_CHECK HMap_GetCount(ht()) = 1, "Count should be 1"
TEST_CHECK HMap_Contains(ht(), "test"), "Key should exist"

HMap_SetInteger ht(), "test", 100
TEST_CHECK HMap_GetInteger(ht(), "test") = 100, "Updated integer value should be 100"
TEST_CHECK HMap_GetCount(ht()) = 1, "Count should still be 1 after update"

TEST_CHECK HMap_Remove(ht(), "test"), "Remove should succeed"
TEST_CHECK_FALSE HMap_Contains(ht(), "test"), "Key should not exist after remove"
TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after remove"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Long Operations"

HMap_SetLong ht(), "long", _LONG_MAX
TEST_CHECK HMap_GetLong(ht(), "long") = _LONG_MAX, "Long value should be" + STR$(_LONG_MAX)
TEST_CHECK HMap_GetEntryDataType(ht(), "long") = QBDS_TYPE_LONG, "Data type should be LONG"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Integer64 Operations"

HMap_SetInteger64 ht(), "int64", _INTEGER64_MAX
TEST_CHECK HMap_GetInteger64(ht(), "int64") = _INTEGER64_MAX, "Integer64 value should be" + STR$(_INTEGER64_MAX)
TEST_CHECK HMap_GetEntryDataType(ht(), "int64") = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Single Operations"

HMap_SetSingle ht(), "pi", 3.14!
TEST_CHECK ABS(HMap_GetSingle(ht(), "pi") - 3.14!) < 0.0001, "Single value should be approximately 3.14"
TEST_CHECK HMap_GetEntryDataType(ht(), "pi") = QBDS_TYPE_SINGLE, "Data type should be SINGLE"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Double Operations"

HMap_SetDouble ht(), "e", 2.71828182845905D+00
TEST_CHECK ABS(HMap_GetDouble(ht(), "e") - 2.71828182845905D+00) < 0.000000001D+00, "Double value should be approximately e"
TEST_CHECK HMap_GetEntryDataType(ht(), "e") = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: String Operations"

HMap_SetString ht(), "hello", "world"
TEST_CHECK HMap_GetString(ht(), "hello") = "world", "String value should be 'world'"
TEST_CHECK HMap_GetEntryDataType(ht(), "hello") = QBDS_TYPE_STRING, "Data type should be STRING"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Multiple Items"

DIM i AS _UNSIGNED LONG
DIM currentCount AS LONG: currentCount = HMap_GetCount(ht())
FOR i = 1 TO 100
    HMap_SetInteger ht(), "key" + _TOSTR$(i), i
NEXT
TEST_CHECK HMap_GetCount(ht()) = currentCount + 100, "Count should be " + STR$(currentCount + 100)

FOR i = 1 TO 100
    TEST_CHECK HMap_GetInteger(ht(), "key" + _TOSTR$(i)) = i, "Value should match key"
NEXT

DIM capacity AS _UNSIGNED LONG: capacity = HMap_GetCapacity(ht())

HMap_Clear ht()
TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after clear"
TEST_CHECK_FALSE HMap_Contains(ht(), "key1"), "No keys should exist after clear"
TEST_CHECK HMap_GetCapacity(ht()) = capacity, "Capacity should remain the same after clear"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Multiple Hash Maps"

REDIM students(0) AS HMap ' Student ID -> Name
REDIM grades(0) AS HMap ' Student ID -> Grade
REDIM attendance(0) AS HMap ' Student ID -> Days Present

HMap_Initialize students()
HMap_Initialize grades()
HMap_Initialize attendance()

HMap_SetString students(), "101", "John Smith"
HMap_SetString students(), "102", "Jane Doe"
HMap_SetString students(), "103", "Bob Wilson"

HMap_SetInteger grades(), "101", 85
HMap_SetInteger grades(), "102", 92
HMap_SetInteger grades(), "103", 78

HMap_SetInteger attendance(), "101", 45
HMap_SetInteger attendance(), "102", 50
HMap_SetInteger attendance(), "103", 48

TEST_CHECK HMap_GetCount(students()) = 3, "Students table should have 3 entries"
TEST_CHECK HMap_GetCount(grades()) = 3, "Grades table should have 3 entries"
TEST_CHECK HMap_GetCount(attendance()) = 3, "Attendance table should have 3 entries"

TEST_CHECK HMap_GetString(students(), "102") = "Jane Doe", "Should find Jane Doe"
TEST_CHECK HMap_GetInteger(grades(), "102") = 92, "Jane's grade should be 92"
TEST_CHECK HMap_GetInteger(attendance(), "102") = 50, "Jane's attendance should be 50"

TEST_CHECK HMap_Remove(students(), "101"), "Remove should succeed"
TEST_CHECK HMap_GetCount(students()) = 2, "Students table should have 2 entries after remove"
TEST_CHECK HMap_GetCount(grades()) = 3, "Grades table should still have 3 entries"
TEST_CHECK HMap_GetCount(attendance()) = 3, "Attendance table should still have 3 entries"
TEST_CHECK HMap_GetInteger(grades(), "101") = 85, "Removed student's grade should still exist"

HMap_Clear students()
HMap_Clear grades()
HMap_Clear attendance()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST PERF_TEST_KEY_COUNT = 1000000

REDIM testTable(0) AS HMap
DIM keyStr AS STRING
DIM valueStr AS STRING
DIM perfTestIndex AS LONG

HMap_Initialize testTable()

TEST_CASE_BEGIN "HMap: Performance Test: Insert (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
    keyStr = "key" + _TOSTR$(perfTestIndex)
    valueStr = "value" + _TOSTR$(perfTestIndex)
    HMap_SetString testTable(), keyStr, valueStr
NEXT

TEST_CASE_END

HMap_Clear testTable()

TEST_CASE_BEGIN "HMap: Performance Test: Insert after Clear (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
    keyStr = "key" + _TOSTR$(perfTestIndex)
    valueStr = "value" + _TOSTR$(perfTestIndex)
    HMap_SetString testTable(), keyStr, valueStr
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: GetCount after Insert"
TEST_CHECK HMap_GetCount(testTable()) = PERF_TEST_KEY_COUNT, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT) + " items"
TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: Get (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
    keyStr = "key" + _TOSTR$(perfTestIndex)
    valueStr = HMap_GetString(testTable(), keyStr)
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: Last key & value pair after Insert"
TEST_CHECK HMap_GetString(testTable(), keyStr) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: Set (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
    keyStr = "key" + _TOSTR$(perfTestIndex)
    valueStr = "value" + _TOSTR$(perfTestIndex + 33)
    HMap_SetString testTable(), keyStr, valueStr
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: Last key & value pair after Update"
TEST_CHECK HMap_GetString(testTable(), keyStr) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT + 33), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT + 33)
TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: Mixed Insert & Remove (" + _TOSTR$(PERF_TEST_KEY_COUNT) + " items)"

FOR perfTestIndex = 1 TO PERF_TEST_KEY_COUNT
    IF perfTestIndex AND 1 THEN
        keyStr = "newkey" + _TOSTR$(perfTestIndex)
        HMap_SetString testTable(), keyStr, "new value"
    ELSE
        keyStr = "key" + _TOSTR$(perfTestIndex)
        HMap_Remove testTable(), keyStr
    END IF
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap: Performance Test: GetCount after mixed Insert & Remove"
TEST_CHECK HMap_GetCount(testTable()) = PERF_TEST_KEY_COUNT, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT) + " items"
HMap_Free testTable()
TEST_CHECK_FALSE HMap_IsInitialized(testTable()), "Should return _FALSE after HMap_Free"
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Edge Cases"

HMap_SetString ht(), _STR_EMPTY, "empty"
TEST_CHECK HMap_GetCount(ht()) = 1, "Count should be 1"
TEST_CHECK HMap_Contains(ht(), _STR_EMPTY), "Key should exist"

HMap_SetString ht(), STRING$(256, "A"), "test"
TEST_CHECK HMap_GetCount(ht()) = 2, "Count should be 2"
TEST_CHECK HMap_Contains(ht(), STRING$(256, "A")), "Key should exist"

TEST_CHECK_FALSE HMap_Contains(ht(), "nonexistent"), "Exists with nonexistent key should return false"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Collisions"

HMap_Clear ht()

' These are known to cause collisions when used with FNV-1a hash
DIM AS STRING collisionKeys(1 TO 10)
collisionKeys(1) = "8yn0iYCKYHlIj4-BwPqk": collisionKeys(2) = "GReLUrM4wMqfg9yzV3KQ"
collisionKeys(3) = "gMPflVXtwGDXbIhP73TX": collisionKeys(4) = "LtHf1prlU1bCeYZEdqWf"
collisionKeys(5) = "pFuM83THhM-Qw8FI5FKo": collisionKeys(6) = ".jPx7rOtTDteKAwvfOEo"
collisionKeys(7) = "7mohtcOFVz": collisionKeys(8) = "c1E51sSEyx"
collisionKeys(9) = "6a5x-VbtXk": collisionKeys(10) = "f_2k7GG-4v"

FOR i = 1 TO 10
    HMap_SetString ht(), collisionKeys(i), "value" + _TOSTR$(i)
NEXT

TEST_CHECK HMap_GetCount(ht()) = 10, "Should have 10 items after collision insertions"

FOR i = 1 TO 10
    TEST_CHECK HMap_GetString(ht(), collisionKeys(i)) = "value" + _TOSTR$(i), "Collision values should be retrievable"
NEXT

HMap_Remove ht(), collisionKeys(3)
HMap_Remove ht(), collisionKeys(7)

TEST_CHECK HMap_GetCount(ht()) = 8, "Should have 8 items after deleting from collision chain"
TEST_CHECK_FALSE HMap_Contains(ht(), collisionKeys(3)), "Removed collision item should not exist"
TEST_CHECK HMap_GetString(ht(), collisionKeys(4)) = "value4", "Remaining collision items should be intact"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Cleanup"

HMap_Clear ht()
TEST_CHECK HMap_GetCount(ht()) = 0, "Count should be 0 after clear"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap: Free"

HMap_Free ht()
TEST_CHECK_FALSE HMap_IsInitialized(ht()), "Should return _FALSE after HMap_Free"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap64: Basic Operations"

REDIM intMap(0) AS HMap64

HMap64_Initialize intMap()
TEST_CHECK HMap64_GetCount(intMap()) = 0, "Initial count should be 0"
TEST_CHECK_FALSE HMap64_Contains(intMap(), 123456), "Nonexistent key should not exist"
TEST_CHECK HMap64_GetString(intMap(), 123456) = "", "Getting nonexistent key should return empty string"

HMap64_SetString intMap(), &HDEADBEEFCAFEBABE~&&, "test"
TEST_CHECK HMap64_GetString(intMap(), &HDEADBEEFCAFEBABE~&&) = "test", "String value should be test"
TEST_CHECK HMap64_GetEntryDataType(intMap(), &HDEADBEEFCAFEBABE~&&) = QBDS_TYPE_STRING, "Data type should be STRING"

HMap64_SetByte intMap(), 42~&&, 123~%%
TEST_CHECK HMap64_GetByte(intMap(), 42~&&) = 123~%%, "Byte value should be 123"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 42~&&) = QBDS_TYPE_BYTE, "Data type should be BYTE"

HMap64_SetInteger intMap(), 1~&&, 12345%
TEST_CHECK HMap64_GetInteger(intMap(), 1~&&) = 12345%, "Integer value should be 12345"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 1~&&) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"

HMap64_SetLong intMap(), 2~&&, 123456&
TEST_CHECK HMap64_GetLong(intMap(), 2~&&) = 123456&, "Long value should be 123456"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 2~&&) = QBDS_TYPE_LONG, "Data type should be LONG"

HMap64_SetInteger64 intMap(), 3~&&, _INTEGER64_MAX
TEST_CHECK HMap64_GetInteger64(intMap(), 3~&&) = _INTEGER64_MAX, "Integer64 value should be _INTEGER64_MAX"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 3~&&) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"

HMap64_SetSingle intMap(), 4~&&, 3.14159!
TEST_CHECK ABS(HMap64_GetSingle(intMap(), 4~&&) - 3.14159!) < 0.0001, "Single value should be approximately 3.14159"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 4~&&) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"

HMap64_SetDouble intMap(), 5~&&, 2.71828182845905D+00
TEST_CHECK ABS(HMap64_GetDouble(intMap(), 5~&&) - 2.71828182845905D+00) < 0.000000001D+00, "Double value should be approximately e"
TEST_CHECK HMap64_GetEntryDataType(intMap(), 5~&&) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"

TEST_CHECK HMap64_GetCount(intMap()) = 7, "Total count should be 7"

TEST_CHECK HMap64_Remove(intMap(), 42~&&), "Remove should succeed"
TEST_CHECK_FALSE HMap64_Contains(intMap(), 42~&&), "Key should not exist after remove"
TEST_CHECK HMap64_GetCount(intMap()) = 6, "Count should be 6 after delete"

HMap64_SetString intMap(), &HDEADBEEFCAFEBABE~&&, "updated"
TEST_CHECK HMap64_GetString(intMap(), &HDEADBEEFCAFEBABE~&&) = "updated", "String value should be updated"
TEST_CHECK HMap64_GetCount(intMap()) = 6, "Count should still be 6 after update"

HMap64_Clear intMap()
TEST_CHECK HMap64_GetCount(intMap()) = 0, "Count should be 0 after clear"
TEST_CHECK_FALSE HMap64_Contains(intMap(), 1~&&), "No keys should exist after clear"

HMap64_Free intMap()
TEST_CHECK_FALSE HMap64_IsInitialized(intMap()), "Should return _FALSE after HMap64_Free"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST PERF_TEST_KEY_COUNT64 = 1000000

REDIM testTable64(0) AS HMap64
DIM key64 AS _UNSIGNED _INTEGER64
DIM valueStr64 AS STRING
DIM perfTestIndex64 AS LONG

HMap64_Initialize testTable64()

TEST_CASE_BEGIN "HMap64: Performance Test: Insert (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
    key64 = perfTestIndex64
    valueStr64 = "value" + _TOSTR$(perfTestIndex64)
    HMap64_SetString testTable64(), key64, valueStr64
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: GetCount after Insert"
TEST_CHECK HMap64_GetCount(testTable64()) = PERF_TEST_KEY_COUNT64, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items"
TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: Get (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
    key64 = perfTestIndex64
    valueStr64 = HMap64_GetString(testTable64(), key64)
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: Last key & value pair after Insert"
TEST_CHECK HMap64_GetString(testTable64(), key64) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT64), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT64)
TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: Set (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
    key64 = perfTestIndex64
    valueStr64 = "value" + _TOSTR$(perfTestIndex64 + 33)
    HMap64_SetString testTable64(), key64, valueStr64
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: Last key & value pair after Update"
TEST_CHECK HMap64_GetString(testTable64(), key64) = "value" + _TOSTR$(PERF_TEST_KEY_COUNT64 + 33), "The last value should be value" + _TOSTR$(PERF_TEST_KEY_COUNT64 + 33)
TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: Mixed Insert & Remove (" + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items)"

FOR perfTestIndex64 = 1 TO PERF_TEST_KEY_COUNT64
    IF perfTestIndex64 AND 1 THEN
        key64 = PERF_TEST_KEY_COUNT64 + perfTestIndex64
        HMap64_SetString testTable64(), key64, "new value"
    ELSE
        key64 = perfTestIndex64
        HMap64_Remove testTable64(), key64
    END IF
NEXT

TEST_CASE_END

TEST_CASE_BEGIN "HMap64: Performance Test: GetCount after mixed Insert & Remove"
TEST_CHECK HMap64_GetCount(testTable64()) = PERF_TEST_KEY_COUNT64, "Should have " + _TOSTR$(PERF_TEST_KEY_COUNT64) + " items"
HMap64_Free testTable64()
TEST_CHECK_FALSE HMap64_IsInitialized(testTable64()), "Should return _FALSE after HMap64_Free"
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HMap64: Edge Cases"

HMap64_Initialize intMap()

HMap64_SetString intMap(), 0, "zero"
TEST_CHECK HMap64_GetString(intMap(), 0) = "zero", "Should handle key 0"
TEST_CHECK HMap64_GetCount(intMap()) = 1, "Count should be 1"

HMap64_Remove intMap(), 0
TEST_CHECK_FALSE HMap64_Contains(intMap(), 0), "Should be able to remove key 0"
TEST_CHECK HMap64_GetCount(intMap()) = 0, "Count should be 0"

HMap64_Free intMap()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: Initialization"

REDIM l(0) AS LList

LList_Initialize l()
TEST_CHECK LList_GetCount(l()) = 0, "Initial count should be 0"
TEST_CHECK LList_GetCapacity(l()) > 1, "Capacity should be more than 1"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: Basic String Operations"

LList_PushBackString l(), "Hello"
TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"
TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "Hello", "String value should be Hello"

LList_PushFrontString l(), "World"
TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2"
TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "World", "String value should be World"

TEST_CHECK LList_PopBackString(l()) = "Hello", "Popped value should be Hello"
TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"

TEST_CHECK LList_PopFrontString(l()) = "World", "Popped value should be World"
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0"

LList_Clear l()
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after clear"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: Insert and Delete"

LList_Clear l()

LList_PushBackString l(), "A"
LList_PushBackString l(), "B"
LList_PushBackString l(), "C"

TEST_CHECK LList_GetCount(l()) = 3, "Count should be 3"
TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "A", "Value at front should be A"
TEST_CHECK LList_GetString(l(), LList_GetNextNode(l(), LList_GetFrontNode(l()))) = "B", "Value after front should be B"
TEST_CHECK LList_GetString(l(), LList_GetPreviousNode(l(), LList_GetBackNode(l()))) = "B", "Value before back should be B"
TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

LList_RemoveNode l(), LList_GetNextNode(l(), LList_GetFrontNode(l()))
TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2"
TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "A", "Value at front should be A"
TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

LList_RemoveNode l(), LList_GetFrontNode(l())
TEST_CHECK LList_GetCount(l()) = 1, "Count should be 1"
TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "C", "Value at front should be C"
TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "C", "Value at back should be C"

LList_RemoveNode l(), LList_GetBackNode(l())
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0"

LList_Clear l()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: Circular List"

LList_Clear l()

LList_PushBackString l(), "A"
LList_PushBackString l(), "B"
LList_PushBackString l(), "C"

LList_MakeCircular l(), _TRUE

TEST_CHECK LList_IsCircular(l()), "List should be circular"

DIM head AS _UNSIGNED _OFFSET: head = LList_GetFrontNode(l())
DIM tail AS _UNSIGNED _OFFSET: tail = LList_GetBackNode(l())

TEST_CHECK LList_GetNextNode(l(), tail) = head, "Tail should point to head"
TEST_CHECK LList_GetPreviousNode(l(), head) = tail, "Head should point to tail"

LList_MakeCircular l(), _FALSE

TEST_CHECK_FALSE LList_IsCircular(l()), "List should not be circular"

TEST_CHECK LList_GetNextNode(l(), tail) = 0, "Tail should point to null"
TEST_CHECK LList_GetPreviousNode(l(), head) = 0, "Head should point to null"

LList_Clear l()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: All Data Types"

LList_Clear l()

LList_PushBackByte l(), 127
TEST_CHECK LList_GetByte(l(), LList_GetBackNode(l())) = 127, "Byte value should be 127"
TEST_CHECK LList_PopFrontByte(l()) = 127, "Popped byte value should be 127"

LList_PushBackInteger l(), 32767
TEST_CHECK LList_GetInteger(l(), LList_GetBackNode(l())) = 32767, "Integer value should be 32767"
TEST_CHECK LList_PopFrontInteger(l()) = 32767, "Popped integer value should be 32767"

LList_PushBackLong l(), 2147483647
TEST_CHECK LList_GetLong(l(), LList_GetBackNode(l())) = 2147483647, "Long value should be 2147483647"
TEST_CHECK LList_PopFrontLong(l()) = 2147483647, "Popped long value should be 2147483647"

LList_PushBackInteger64 l(), 9223372036854775807~&&
TEST_CHECK LList_GetInteger64(l(), LList_GetBackNode(l())) = 9223372036854775807~&&, "Integer64 value should be max"
TEST_CHECK LList_PopFrontInteger64(l()) = 9223372036854775807~&&, "Popped integer64 value should be max"

LList_PushBackSingle l(), 1.2345!
TEST_CHECK ABS(LList_GetSingle(l(), LList_GetBackNode(l())) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
TEST_CHECK ABS(LList_PopFrontSingle(l()) - 1.2345!) < 0.0001, "Popped single value should be approx 1.2345"

LList_PushBackDouble l(), 1.23456789#
TEST_CHECK ABS(LList_GetDouble(l(), LList_GetBackNode(l())) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
TEST_CHECK ABS(LList_PopFrontDouble(l()) - 1.23456789#) < 0.00000001, "Popped double value should be approx 1.23456789"

TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after all pops"

LList_Clear l()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "LList: Edge Cases"

LList_Clear l()

LList_Clear l()
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after clearing an empty list"

LList_Free l()
TEST_CHECK_FALSE LList_IsInitialized(l()), "List should not be initialized after free"

LList_Initialize l()

LList_PushBackString l(), "first"
LList_InsertAfterString l(), LList_GetFrontNode(l()), "second"
TEST_CHECK LList_GetCount(l()) = 2, "Count should be 2 after insert"
TEST_CHECK LList_GetString(l(), LList_GetBackNode(l())) = "second", "Second element should be 'second'"
TEST_CHECK LList_GetString(l(), LList_GetFrontNode(l())) = "first", "First element should still be 'first'"

LList_Clear l()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST LL_PERF_COUNT = 1000000

LList_Clear l()

TEST_CASE_BEGIN "LList: Performance Test - PushBack (" + _TOSTR$(LL_PERF_COUNT) + " items)"
FOR i = 1 TO LL_PERF_COUNT
    LList_PushBackInteger64 l(), i
NEXT
TEST_CHECK LList_GetCount(l()) = LL_PERF_COUNT, "Count should be " + _TOSTR$(LL_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "LList: Performance Test - Forward Iteration"
DIM currentNode AS _UNSIGNED _OFFSET: currentNode = LList_GetFrontNode(l())
DIM currentVal AS _UNSIGNED LONG: currentVal = 1
WHILE currentNode <> 0
    TEST_CHECK LList_GetInteger64(l(), currentNode) = currentVal, "Value should be " + _TOSTR$(currentVal)
    currentNode = LList_GetNextNode(l(), currentNode)
    currentVal = currentVal + 1
WEND
TEST_CASE_END

DIM v AS _UNSIGNED LONG

TEST_CASE_BEGIN "LList: Performance Test - PopFront (" + _TOSTR$(LL_PERF_COUNT) + " items)"
FOR i = 1 TO LL_PERF_COUNT
    v = LList_PopFrontInteger64(l())
NEXT
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after popping all items"
TEST_CASE_END

TEST_CASE_BEGIN "LList: Performance Test - PushFront (" + _TOSTR$(LL_PERF_COUNT) + " items)"
LList_Clear l()
FOR i = 1 TO LL_PERF_COUNT
    LList_PushFrontInteger64 l(), i
NEXT
TEST_CHECK LList_GetCount(l()) = LL_PERF_COUNT, "Count should be " + _TOSTR$(LL_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "LList: Performance Test - Backward Iteration"
currentNode = LList_GetBackNode(l())
currentVal = 1
WHILE currentNode <> 0
    TEST_CHECK LList_GetInteger64(l(), currentNode) = currentVal, "Value should be " + _TOSTR$(currentVal)
    currentNode = LList_GetPreviousNode(l(), currentNode)
    currentVal = currentVal + 1
WEND
TEST_CASE_END

TEST_CASE_BEGIN "LList: Performance Test - PopBack (" + _TOSTR$(LL_PERF_COUNT) + " items)"
FOR i = 1 TO LL_PERF_COUNT
    v = LList_PopBackInteger64(l())
NEXT
TEST_CHECK LList_GetCount(l()) = 0, "Count should be 0 after popping all items"
TEST_CASE_END

LList_Free l()

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Stack: Initialization"

REDIM s(0) AS Stack

Stack_Initialize s()
TEST_CHECK Stack_GetCount(s()) = 0, "Initial count should be 0"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Stack: Basic Integer Operations"

Stack_PushInteger s(), 42
TEST_CHECK Stack_PeekInteger(s()) = 42, "Integer value should be 42"
TEST_CHECK Stack_PeekElementDataType(s()) = QBDS_TYPE_INTEGER, "Data type should be INT"
TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1"

Stack_PushInteger s(), 100
TEST_CHECK Stack_PeekInteger(s()) = 100, "Pushed integer value should be 100"
TEST_CHECK Stack_GetCount(s()) = 2, "Count should be 2 after update"

TEST_CHECK Stack_PopInteger(s()) = 100, "Popped integer should be 100"
TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1 after pop"

TEST_CHECK Stack_PopInteger(s()) = 42, "Popped integer should be 42"
TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after pop"

Stack_Clear s()
TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after clear"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Stack: All Data Types"

Stack_Clear s()

Stack_PushString s(), "hello"
TEST_CHECK Stack_PeekString(s()) = "hello", "String value should be 'hello'"
TEST_CHECK Stack_PopString(s()) = "hello", "Popped string value should be 'hello'"

Stack_PushByte s(), 127
TEST_CHECK Stack_PeekByte(s()) = 127, "Byte value should be 127"
TEST_CHECK Stack_PopByte(s()) = 127, "Popped byte value should be 127"

Stack_PushLong s(), -2147483648
TEST_CHECK Stack_PeekLong(s()) = -2147483648, "Long value should be min"
TEST_CHECK Stack_PopLong(s()) = -2147483648, "Popped long value should be min"

Stack_PushInteger64 s(), -9223372036854775808~&&
TEST_CHECK Stack_PeekInteger64(s()) = -9223372036854775808~&&, "Integer64 value should be min"
TEST_CHECK Stack_PopInteger64(s()) = -9223372036854775808~&&, "Popped integer64 value should be min"

Stack_PushSingle s(), -1.2345!
TEST_CHECK ABS(Stack_PeekSingle(s()) - -1.2345!) < 0.0001, "Single value should be approx -1.2345"
TEST_CHECK ABS(Stack_PopSingle(s()) - -1.2345!) < 0.0001, "Popped single value should be approx -1.2345"

Stack_PushDouble s(), -1.23456789#
TEST_CHECK ABS(Stack_PeekDouble(s()) - -1.23456789#) < 0.00000001, "Double value should be approx -1.23456789"
TEST_CHECK ABS(Stack_PopDouble(s()) - -1.23456789#) < 0.00000001, "Popped double value should be approx -1.23456789"

TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after all pops"

Stack_Clear s()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Stack: Edge Cases"

Stack_Clear s()
TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after clearing an empty stack"
Stack_PushString s(), ""
TEST_CHECK Stack_GetCount(s()) = 1, "Count should be 1 after pushing an empty string"
TEST_CHECK Stack_PopString(s()) = "", "Popped value should be an empty string"

Stack_Free s()
TEST_CHECK_FALSE Stack_IsInitialized(s()), "Stack should not be initialized after free"

Stack_Initialize s()
TEST_CHECK Stack_IsInitialized(s()), "Stack should be initialized"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST STACK_PERF_COUNT = 1000000

Stack_Clear s()

TEST_CASE_BEGIN "Stack: Performance Test - Push (" + _TOSTR$(STACK_PERF_COUNT) + " items)"
FOR i = 1 TO STACK_PERF_COUNT
    Stack_PushInteger64 s(), i
NEXT
TEST_CHECK Stack_GetCount(s()) = STACK_PERF_COUNT, "Count should be " + _TOSTR$(STACK_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "Stack: Performance Test - Pop (" + _TOSTR$(STACK_PERF_COUNT) + " items)"
FOR i = STACK_PERF_COUNT TO 1 STEP -1
    TEST_CHECK Stack_PopInteger64(s()) = i, "Popped value should be " + _TOSTR$(i)
NEXT
TEST_CHECK Stack_GetCount(s()) = 0, "Count should be 0 after popping all items"
Stack_Free s()
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Array: Initialization"

REDIM arr(0) AS Array

Array_Initialize arr()
TEST_CHECK Array_IsInitialized(arr()), "Array should be initialized"
TEST_CHECK Array_GetCount(arr()) = 0, "Initial count should be 0"
TEST_CHECK Array_GetCapacity(arr()) > 0, "Initial capacity should be greater than 0"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Array: Basic String Operations"

Array_PushBackString arr(), "Hello"
TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1"
TEST_CHECK Array_GetString(arr(), 1) = "Hello", "String value should be 'Hello'"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_STRING, "Data type should be STRING"

Array_PushBackString arr(), "World"
TEST_CHECK Array_GetCount(arr()) = 2, "Count should be 2"
TEST_CHECK Array_GetString(arr(), 2) = "World", "String value should be 'World'"

Array_SetString arr(), 1, "Hi"
TEST_CHECK Array_GetString(arr(), 1) = "Hi", "Set string should be 'Hi'"
TEST_CHECK Array_GetCount(arr()) = 2, "Count should still be 2 after set"

TEST_CHECK Array_PopBackString(arr()) = "World", "Popped value should be 'World'"
TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1 after pop"

TEST_CHECK Array_PopBackString(arr()) = "Hi", "Popped value should be 'Hi'"
TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after pop"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Array: All Data Types"

Array_Clear arr()

Array_PushBackByte arr(), 127
TEST_CHECK Array_GetByte(arr(), 1) = 127, "Byte value should be 127"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_BYTE, "Data type should be BYTE"
TEST_CHECK Array_PopBackByte(arr()) = 127, "Popped byte value should be 127"

Array_PushBackInteger arr(), 32767
TEST_CHECK Array_GetInteger(arr(), 1) = 32767, "Integer value should be 32767"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"
TEST_CHECK Array_PopBackInteger(arr()) = 32767, "Popped integer value should be 32767"

Array_PushBackLong arr(), 2147483647
TEST_CHECK Array_GetLong(arr(), 1) = 2147483647, "Long value should be 2147483647"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_LONG, "Data type should be LONG"
TEST_CHECK Array_PopBackLong(arr()) = 2147483647, "Popped long value should be 2147483647"

Array_PushBackInteger64 arr(), 9223372036854775807~&&
TEST_CHECK Array_GetInteger64(arr(), 1) = 9223372036854775807~&&, "Integer64 value should be max"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"
TEST_CHECK Array_PopBackInteger64(arr()) = 9223372036854775807~&&, "Popped integer64 value should be max"

Array_PushBackSingle arr(), 1.2345!
TEST_CHECK ABS(Array_GetSingle(arr(), 1) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"
TEST_CHECK ABS(Array_PopBackSingle(arr()) - 1.2345!) < 0.0001, "Popped single value should be approx 1.2345"

Array_PushBackDouble arr(), 1.23456789#
TEST_CHECK ABS(Array_GetDouble(arr(), 1) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
TEST_CHECK Array_GetElementDataType(arr(), 1) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"
TEST_CHECK ABS(Array_PopBackDouble(arr()) - 1.23456789#) < 0.00000001, "Popped double value should be approx 1.23456789"

TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after all pops"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Array: Capacity and Growth"

Array_Clear arr()
DIM initialCapacity AS LONG: initialCapacity = Array_GetCapacity(arr())

FOR i = 1 TO initialCapacity + 1
    Array_PushBackInteger arr(), i
NEXT

TEST_CHECK Array_GetCount(arr()) = initialCapacity + 1, "Count should be initialCapacity + 1"
TEST_CHECK Array_GetCapacity(arr()) > initialCapacity, "Capacity should have grown"

Array_Clear arr()
TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after clear"
TEST_CHECK Array_GetCapacity(arr()) > initialCapacity, "Capacity should remain the same after clear"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Array: Edge Cases"

Array_Clear arr()
TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after clearing an empty array"
Array_PushBackString arr(), ""
TEST_CHECK Array_GetCount(arr()) = 1, "Count should be 1 after pushing an empty string"
TEST_CHECK Array_PopBackString(arr()) = "", "Popped value should be an empty string"

Array_Free arr()
TEST_CHECK_FALSE Array_IsInitialized(arr()), "Array should not be initialized after free"

Array_Initialize arr()
TEST_CHECK Array_IsInitialized(arr()), "Array should be initialized again"

Array_Free arr()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST ARRAY_PERF_COUNT = 1000000

Array_Initialize arr()

TEST_CASE_BEGIN "Array: Performance Test - PushBack (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
FOR i = 1 TO ARRAY_PERF_COUNT
    Array_PushBackLong arr(), i
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - GetCount after PushBack"
TEST_CHECK Array_GetCount(arr()) = ARRAY_PERF_COUNT, "Count should be " + _TOSTR$(ARRAY_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - Get (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
FOR i = 1 TO ARRAY_PERF_COUNT
    v = Array_GetLong(arr(), i)
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - Last value after Get"
TEST_CHECK v = ARRAY_PERF_COUNT, "Last value should be " + _TOSTR$(ARRAY_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - Set (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
FOR i = 1 TO ARRAY_PERF_COUNT
    Array_SetLong arr(), i, i + 1
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - Last value after Set"
TEST_CHECK Array_GetLong(arr(), ARRAY_PERF_COUNT) = ARRAY_PERF_COUNT + 1, "Last value should be " + _TOSTR$(ARRAY_PERF_COUNT + 1)
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - PopBack (" + _TOSTR$(ARRAY_PERF_COUNT) + " items)"
FOR i = 1 TO ARRAY_PERF_COUNT
    v = Array_PopBackLong(arr())
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Array: Performance Test - GetCount after PopBack"
TEST_CHECK Array_GetCount(arr()) = 0, "Count should be 0 after popping all items"
TEST_CASE_END

Array_Free arr()

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Queue: Initialization"

REDIM q(0) AS Queue

Queue_Initialize q()
TEST_CHECK Queue_IsInitialized(q()), "Queue should be initialized"
TEST_CHECK Queue_GetCount(q()) = 0, "Initial count should be 0"
TEST_CHECK Queue_GetCapacity(q()) > 0, "Initial capacity should be greater than 0"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Queue: All Data Types"

Queue_Clear q()

Queue_EnqueueByte q(), 127
TEST_CHECK Queue_PeekByte(q()) = 127, "Byte value should be 127"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_BYTE, "Data type should be BYTE"
TEST_CHECK Queue_DequeueByte(q()) = 127, "Dequeued byte value should be 127"

Queue_EnqueueInteger q(), 32767
TEST_CHECK Queue_PeekInteger(q()) = 32767, "Integer value should be 32767"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_INTEGER, "Data type should be INTEGER"
TEST_CHECK Queue_DequeueInteger(q()) = 32767, "Dequeued integer value should be 32767"

Queue_EnqueueLong q(), 2147483647
TEST_CHECK Queue_PeekLong(q()) = 2147483647, "Long value should be 2147483647"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_LONG, "Data type should be LONG"
TEST_CHECK Queue_DequeueLong(q()) = 2147483647, "Dequeued long value should be 2147483647"

Queue_EnqueueInteger64 q(), 9223372036854775807~&&
TEST_CHECK Queue_PeekInteger64(q()) = 9223372036854775807~&&, "Integer64 value should be max"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_INTEGER64, "Data type should be INTEGER64"
TEST_CHECK Queue_DequeueInteger64(q()) = 9223372036854775807~&&, "Dequeued integer64 value should be max"

Queue_EnqueueSingle q(), 1.2345!
TEST_CHECK ABS(Queue_PeekSingle(q()) - 1.2345!) < 0.0001, "Single value should be approx 1.2345"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_SINGLE, "Data type should be SINGLE"
TEST_CHECK ABS(Queue_DequeueSingle(q()) - 1.2345!) < 0.0001, "Dequeued single value should be approx 1.2345"

Queue_EnqueueDouble q(), 1.23456789#
TEST_CHECK ABS(Queue_PeekDouble(q()) - 1.23456789#) < 0.00000001, "Double value should be approx 1.23456789"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_DOUBLE, "Data type should be DOUBLE"
TEST_CHECK ABS(Queue_DequeueDouble(q()) - 1.23456789#) < 0.00000001, "Dequeued double value should be approx 1.23456789"

Queue_EnqueueString q(), "hello"
TEST_CHECK Queue_PeekString(q()) = "hello", "String value should be 'hello'"
TEST_CHECK Queue_PeekElementDataType(q()) = QBDS_TYPE_STRING, "Data type should be STRING"
TEST_CHECK Queue_DequeueString(q()) = "hello", "Dequeued string value should be 'hello'"

TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after all dequeues"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Queue: Growth and Wrapping"

Queue_Clear q()
initialCapacity = Queue_GetCapacity(q())

FOR i = 1 TO initialCapacity
    Queue_EnqueueInteger q(), i
NEXT

TEST_CHECK Queue_GetCount(q()) = initialCapacity, "Queue should be full"

Queue_EnqueueInteger q(), initialCapacity + 1
TEST_CHECK Queue_GetCapacity(q()) > initialCapacity, "Capacity should have grown"
TEST_CHECK Queue_GetCount(q()) = initialCapacity + 1, "Count should be initialCapacity + 1"

FOR i = 1 TO initialCapacity + 1
    TEST_CHECK Queue_DequeueInteger(q()) = i, "Value should be " + _TOSTR$(i)
NEXT

Queue_Clear q()
FOR i = 1 TO initialCapacity
    Queue_EnqueueInteger q(), i
NEXT

FOR i = 1 TO initialCapacity / 2
    TEST_CHECK Queue_DequeueInteger(q()) = i, "Dequeued value should be " + _TOSTR$(i)
NEXT
FOR i = 1 TO initialCapacity / 2
    Queue_EnqueueInteger q(), initialCapacity + i
NEXT

TEST_CHECK Queue_GetCount(q()) = initialCapacity, "Count should be back to initialCapacity"

FOR i = (initialCapacity / 2) + 1 TO initialCapacity + (initialCapacity / 2)
    TEST_CHECK Queue_DequeueInteger(q()) = i, "Dequeued value should be " + _TOSTR$(i)
NEXT

TEST_CHECK Queue_GetCount(q()) = 0, "Queue should be empty"

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "Queue: Edge Cases"

Queue_Clear q()
TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after clearing an empty queue"
Queue_EnqueueString q(), ""
TEST_CHECK Queue_GetCount(q()) = 1, "Count should be 1 after enqueueing an empty string"
TEST_CHECK Queue_DequeueString(q()) = "", "Dequeued value should be an empty string"

Queue_Free q()
TEST_CHECK_FALSE Queue_IsInitialized(q()), "Queue should not be initialized after free"

Queue_Initialize q()
TEST_CHECK Queue_IsInitialized(q()), "Queue should be initialized again"

Queue_Free q()

TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST QUEUE_PERF_COUNT = 1000000

Queue_Initialize q()

TEST_CASE_BEGIN "Queue: Performance Test - Enqueue (" + _TOSTR$(QUEUE_PERF_COUNT) + " items)"
FOR i = 1 TO QUEUE_PERF_COUNT
    Queue_EnqueueLong q(), i
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Queue: Performance Test - GetCount after Enqueue"
TEST_CHECK Queue_GetCount(q()) = QUEUE_PERF_COUNT, "Count should be " + _TOSTR$(QUEUE_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "Queue: Performance Test - Dequeue (" + _TOSTR$(QUEUE_PERF_COUNT) + " items)"
FOR i = 1 TO QUEUE_PERF_COUNT
    v = Queue_DequeueLong(q())
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "Queue: Performance Test - Last value after Dequeue"
TEST_CHECK v = QUEUE_PERF_COUNT, "Last value should be " + _TOSTR$(QUEUE_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "Queue: Performance Test - GetCount after Dequeue"
TEST_CHECK Queue_GetCount(q()) = 0, "Count should be 0 after dequeuing all items"
TEST_CASE_END

Queue_Free q()

'-----------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HSet: Initialization and Basic Operations"
REDIM mySet(0) AS HSet
HSet_Initialize mySet()
TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0"
HSet_AddString mySet(), "Apple"
HSet_AddString mySet(), "Banana"
HSet_AddString mySet(), "Apple" ' Add duplicate
TEST_CHECK HSet_GetCount(mySet()) = 2, "Set count should be 2"
TEST_CHECK HSet_ContainsString(mySet(), "Apple"), "Set should contain 'Apple'"
TEST_CHECK HSet_ContainsString(mySet(), "Banana"), "Set should contain 'Banana'"
TEST_CHECK_FALSE HSet_ContainsString(mySet(), "Cherry"), "Set should not contain 'Cherry'"
TEST_CHECK HSet_RemoveString(mySet(), "Apple"), "Removing 'Apple' should succeed"
TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1 after remove"
TEST_CHECK_FALSE HSet_ContainsString(mySet(), "Apple"), "Set should not contain 'Apple' after removal"
HSet_Free mySet()
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HSet: All Data Types"
HSet_Initialize mySet()

HSet_AddByte mySet(), 127
TEST_CHECK HSet_ContainsByte(mySet(), 127), "Set should contain byte 127"
TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"
HSet_AddByte mySet(), 127
TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should still be 1"
TEST_CHECK HSet_RemoveByte(mySet(), 127), "Removing byte 127 should succeed"
TEST_CHECK_FALSE HSet_ContainsByte(mySet(), 127), "Set should not contain byte 127"

HSet_AddInteger mySet(), -32768
TEST_CHECK HSet_ContainsInteger(mySet(), -32768), "Set should contain integer -32768"
TEST_CHECK HSet_RemoveInteger(mySet(), -32768), "Removing integer -32768 should succeed"

HSet_AddLong mySet(), 2147483647
TEST_CHECK HSet_ContainsLong(mySet(), 2147483647), "Set should contain long 2147483647"
TEST_CHECK HSet_RemoveLong(mySet(), 2147483647), "Removing long 2147483647 should succeed"

HSet_AddInteger64 mySet(), 9223372036854775807~&&
TEST_CHECK HSet_ContainsInteger64(mySet(), 9223372036854775807~&&), "Set should contain int64 max"
TEST_CHECK HSet_RemoveInteger64(mySet(), 9223372036854775807~&&), "Removing int64 max should succeed"

HSet_AddSingle mySet(), 3.14!
TEST_CHECK HSet_ContainsSingle(mySet(), 3.14!), "Set should contain single 3.14"
TEST_CHECK HSet_RemoveSingle(mySet(), 3.14!), "Removing single 3.14 should succeed"

HSet_AddDouble mySet(), 2.71828182845905D+00
TEST_CHECK HSet_ContainsDouble(mySet(), 2.71828182845905D+00), "Set should contain double e"
TEST_CHECK HSet_RemoveDouble(mySet(), 2.71828182845905D+00), "Removing double e should succeed"

TEST_CHECK HSet_GetCount(mySet()) = 0, "Set should be empty"
HSet_Free mySet()
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HSet: Edge Cases"
HSet_Initialize mySet()

' Empty string
HSet_AddString mySet(), ""
TEST_CHECK HSet_ContainsString(mySet(), ""), "Set should contain empty string"
TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"
TEST_CHECK HSet_RemoveString(mySet(), ""), "Removing empty string should succeed"
TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0"

' Long string
DIM longString AS STRING: longString = STRING$(1000, "A")
HSet_AddString mySet(), longString
TEST_CHECK HSet_ContainsString(mySet(), longString), "Set should contain long string"
TEST_CHECK HSet_RemoveString(mySet(), longString), "Removing long string should succeed"

' Clear and re-add
HSet_AddString mySet(), "A"
HSet_Clear mySet()
TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0 after clear"
TEST_CHECK_FALSE HSet_ContainsString(mySet(), "A"), "Set should not contain 'A' after clear"
HSet_AddString mySet(), "B"
TEST_CHECK HSet_ContainsString(mySet(), "B"), "Set should contain 'B' after re-adding"
TEST_CHECK HSet_GetCount(mySet()) = 1, "Set count should be 1"

HSet_Free mySet()
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

TEST_CASE_BEGIN "HSet: Collisions"
HSet_Initialize mySet()

FOR i = 1 TO 10
    HSet_AddString mySet(), collisionKeys(i)
NEXT

TEST_CHECK HSet_GetCount(mySet()) = 10, "Set should have 10 items after collision insertions"

FOR i = 1 TO 10
    TEST_CHECK HSet_ContainsString(mySet(), collisionKeys(i)), "Collision values should exist"
NEXT

HSet_RemoveString mySet(), collisionKeys(3)
TEST_CHECK HSet_GetCount(mySet()) = 9, "Should have 9 items after deleting from collision chain"
TEST_CHECK_FALSE HSet_ContainsString(mySet(), collisionKeys(3)), "Removed collision item should not exist"
TEST_CHECK HSet_ContainsString(mySet(), collisionKeys(4)), "Remaining collision items should be intact"

HSet_Free mySet()
TEST_CASE_END

'-----------------------------------------------------------------------------------------------------------------------

CONST HSET_PERF_COUNT = 1000000
DIM perfSetIndex AS LONG
HSet_Initialize mySet()

TEST_CASE_BEGIN "HSet: Performance Test: Add (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
FOR perfSetIndex = 1 TO HSET_PERF_COUNT
    HSet_AddLong mySet(), perfSetIndex
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "HSet: Performance Test: GetCount"
TEST_CHECK HSet_GetCount(mySet()) = HSET_PERF_COUNT, "Set count should be " + _TOSTR$(HSET_PERF_COUNT)
TEST_CASE_END

TEST_CASE_BEGIN "HSet: Performance Test: Contains (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
FOR perfSetIndex = 1 TO HSET_PERF_COUNT
    TEST_CHECK HSet_ContainsLong(mySet(), perfSetIndex), "Should contain item " + _TOSTR$(perfSetIndex)
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "HSet: Performance Test: Remove (" + _TOSTR$(HSET_PERF_COUNT) + " items)"
FOR perfSetIndex = 1 TO HSET_PERF_COUNT
    TEST_CHECK HSet_RemoveLong(mySet(), perfSetIndex), "Should remove item " + _TOSTR$(perfSetIndex)
NEXT
TEST_CASE_END

TEST_CASE_BEGIN "HSet: Performance Test: GetCount after Remove"
TEST_CHECK HSet_GetCount(mySet()) = 0, "Set count should be 0 after removal"
TEST_CASE_END

HSet_Free mySet()

'-----------------------------------------------------------------------------------------------------------------------

TEST_END_ALL

'-----------------------------------------------------------------------------------------------------------------------

