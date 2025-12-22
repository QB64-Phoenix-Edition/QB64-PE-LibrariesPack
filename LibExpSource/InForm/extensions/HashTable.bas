'-----------------------------------------------------------------------------------------------------------------------
' A simple hash table library
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

'$INCLUDE:'HashTable.bi'

'-----------------------------------------------------------------------------------------------------------------------
' Test code for debugging the library
'-----------------------------------------------------------------------------------------------------------------------
'DEFLNG A-Z
'OPTION _EXPLICIT

'CONST TEST_LB = 0
'CONST TEST_UB = 9999999

'WIDTH , 60
'_FONT 14

'REDIM MyHashTable(0) AS HashTableType: HashTable_Initialize MyHashTable()

'DIM myarray(TEST_LB TO TEST_UB) AS LONG, t AS DOUBLE
'DIM AS _UNSIGNED LONG k, i, x

'FOR k = 1 TO 4
'    PRINT "Add element to array..."
'    t = TIMER
'    FOR i = TEST_LB TO TEST_UB
'        myarray(i) = x
'        x = x + 1
'    NEXT
'    PRINT USING "#####.##### seconds"; TIMER - t

'    PRINT "Add element to hash table..."
'    t = TIMER
'    FOR i = TEST_LB TO TEST_UB
'        HashTable_InsertLong MyHashTable(), i, myarray(i)
'    NEXT
'    PRINT USING "#####.##### seconds"; TIMER - t

'    PRINT "Read element from array..."
'    t = TIMER
'    FOR i = TEST_LB TO TEST_UB
'        x = myarray(i)
'    NEXT
'    PRINT USING "#####.##### seconds"; TIMER - t

'    PRINT "Read element from hash table..."
'    t = TIMER
'    FOR i = TEST_LB TO TEST_UB
'        x = HashTable_LookupLong(MyHashTable(), i)
'    NEXT
'    PRINT USING "#####.##### seconds"; TIMER - t

'    PRINT "Remove element from hash table..."
'    t = TIMER
'    FOR i = TEST_LB TO TEST_UB
'        HashTable_Remove MyHashTable(), i
'    NEXT
'    PRINT USING "#####.##### seconds"; TIMER - t
'NEXT

'HashTable_Initialize MyHashTable()

'FOR i = TEST_LB TO TEST_UB
'    HashTable_InsertLong MyHashTable(), i, myarray(i)
'    LOCATE , 1: PRINT "Added key"; i; "Size:"; UBOUND(MyHashTable) + 1;
'NEXT
'PRINT

'FOR i = TEST_LB TO TEST_UB
'    LOCATE , 1: PRINT "Verifying key: "; i;
'    IF HashTable_LookupLong(MyHashTable(), i) <> myarray(i) THEN
'        PRINT "[fail] ";
'        SLEEP 1
'    ELSE
'        PRINT "[pass] ";
'    END IF
'NEXT
'PRINT

'FOR i = TEST_UB TO TEST_LB STEP -1
'    HashTable_Remove MyHashTable(), i
'    LOCATE , 1: PRINT "Removed key"; i; "Size:"; UBOUND(MyHashTable) + 1;
'NEXT
'PRINT

'HashTable_InsertLong MyHashTable(), 42, 666
'HashTable_InsertLong MyHashTable(), 7, 123454321
'HashTable_InsertLong MyHashTable(), 21, 69

'PRINT "Value for key 42:"; HashTable_LookupLong(MyHashTable(), 42)
'PRINT "Value for key 7:"; HashTable_LookupLong(MyHashTable(), 7)
'PRINT "Value for key 21:"; HashTable_LookupLong(MyHashTable(), 21)

'IF NOT HashTable_IsKeyPresent(MyHashTable(), 100) THEN
'    PRINT "Key 100 is not in the table."
'END IF

'HashTable_Insert MyHashTable(), 43, "grape"
'HashTable_Insert MyHashTable(), 8, "carrot"
'HashTable_Insert MyHashTable(), 22, "apple"

'PRINT "Value for key 22: "; HashTable_Lookup(MyHashTable(), 22)
'PRINT "Value for key 8: "; HashTable_Lookup(MyHashTable(), 8)
'PRINT "Value for key 43: "; HashTable_Lookup(MyHashTable(), 43)

'IF HashTable_IsKeyPresent(MyHashTable(), 43) THEN
'    PRINT "key for grape is in the table."
'END IF

'HashTable_Remove MyHashTable(), 8
'IF NOT HashTable_IsKeyPresent(MyHashTable(), 8) THEN
'    PRINT "key for carrot has been removed."
'END IF

'END
'-----------------------------------------------------------------------------------------------------------------------

''' @brief Internal: Simple hash function for 32-bit integers.
''' @param k The LONG key to hash.
''' @param tableSize The UBOUND of array.
''' @return The hashed index within the table bounds.
FUNCTION __HashTable_Hash~& (k AS _UNSIGNED LONG, l AS _UNSIGNED LONG)
    $CHECKING:OFF
    ' Actually this should be k MOD (l + 1)
    ' However, we can get away using AND because our arrays size always doubles in multiples of 2
    ' So, if l = 255, then (k MOD (l + 1)) = (k AND l)
    ' Another nice thing here is that we do not need to do the addition :)
    __HashTable_Hash = k AND l
    $CHECKING:ON
END FUNCTION

''' @brief Internal: Resizes the hash table and rehashes all entries.
''' @param table The hash table to resize and rehash.
SUB __HashTable_ResizeAndRehash (hashTable() AS HashTableType)
    DIM uB AS _UNSIGNED LONG: uB = UBOUND(hashTable)

    ' Resize the array to double its size while preserving contents
    DIM newUB AS _UNSIGNED LONG: newUB = (uB + 1) * 2 - 1
    REDIM _PRESERVE hashTable(0 TO newUB) AS HashTableType

    ' Rehash and swap all the elements
    DIM i AS _UNSIGNED LONG
    FOR i = 0 TO uB
        IF hashTable(i).U THEN SWAP hashTable(i), hashTable(__HashTable_Hash(hashTable(i).K, newUB))
    NEXT i
END SUB

''' @brief Initializes a new hash table.
''' @param table The table to initialize. Will be REDIMed.
SUB HashTable_Initialize (hashTable() AS HashTableType)
    REDIM hashTable(0 TO 0) AS HashTableType
END SUB

''' @brief Checks if a key exists in the table.
''' @param table The hash table to search.
''' @param k The key to check.
''' @return _TRUE if present, _FALSE otherwise.
FUNCTION HashTable_IsKeyPresent%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    HashTable_IsKeyPresent = (hashTable(idx).U _ANDALSO hashTable(idx).K = k)
END FUNCTION

''' @brief Removes a key-value pair by key.
''' @param table The hash table to modify.
''' @param k The key to remove.
''' @return _TRUE if removed, _FALSE if not found.
FUNCTION HashTable_Remove%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    IF hashTable(idx).U _ANDALSO hashTable(idx).K = k THEN
        hashTable(idx).U = _FALSE
        HashTable_Remove = _TRUE
    END IF
END FUNCTION

''' @brief Removes a key-value pair by key.
''' @param table The hash table to modify.
''' @param k The key to remove.
''' @return _TRUE if removed, _FALSE if not found.
SUB HashTable_Remove (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    IF hashTable(idx).U _ANDALSO hashTable(idx).K = k THEN hashTable(idx).U = _FALSE
END SUB

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated value string, or an empty string if not found.
FUNCTION HashTable_Lookup$ (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    IF hashTable(idx).U _ANDALSO hashTable(idx).K = k THEN HashTable_Lookup = hashTable(idx).V
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated _BYTE value.
FUNCTION HashTable_LookupByte%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupByte = _CV(_BYTE, HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated INTEGER value.
FUNCTION HashTable_LookupInteger% (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupInteger = CVI(HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated LONG value.
FUNCTION HashTable_LookupLong& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupLong = CVL(HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated SINGLE value.
FUNCTION HashTable_LookupSingle! (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupSingle = CVS(HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated DOUBLE value.
FUNCTION HashTable_LookupDouble# (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupDouble = CVD(HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Retrieves the value for a given key.
''' @param table The hash table to search.
''' @param k The key to look up.
''' @return The associated _INTEGER64 value.
FUNCTION HashTable_LookupInteger64&& (hashTable() AS HashTableType, k AS _UNSIGNED LONG)
    HashTable_LookupInteger64 = _CV(_INTEGER64, HashTable_Lookup(hashTable(), k))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value string.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_Insert%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS STRING)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    IF hashTable(idx).U THEN
        IF hashTable(idx).K = k THEN
            ' Key already exists
            EXIT FUNCTION
        ELSE
            __HashTable_ResizeAndRehash hashTable()
            HashTable_Insert = HashTable_Insert(hashTable(), k, v)
            EXIT FUNCTION
        END IF
    ELSE
        hashTable(idx).U = _TRUE
        hashTable(idx).K = k
        hashTable(idx).V = v
    END IF

    HashTable_Insert = _TRUE
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value _BYTE.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertByte%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _BYTE)
    HashTable_InsertByte = HashTable_Insert(hashTable(), k, _MK$(_BYTE, v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value INTEGER.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertInteger%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS INTEGER)
    HashTable_InsertInteger = HashTable_Insert(hashTable(), k, MKI$(v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value LONG.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertLong%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS LONG)
    HashTable_InsertLong = HashTable_Insert(hashTable(), k, MKL$(v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value SINGLE.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertSingle%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS SINGLE)
    HashTable_InsertSingle = HashTable_Insert(hashTable(), k, MKS$(v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value DOUBLE.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertDouble%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS DOUBLE)
    HashTable_InsertDouble = HashTable_Insert(hashTable(), k, MKD$(v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value _INTEGER64.
''' @return _TRUE on success, _FALSE if key already exists.
FUNCTION HashTable_InsertInteger64%% (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _INTEGER64)
    HashTable_InsertInteger64 = HashTable_Insert(hashTable(), k, _MK$(_INTEGER64, v))
END FUNCTION

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value string.
SUB HashTable_Insert (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS STRING)
    IF NOT HashTable_Insert(hashTable(), k, v) THEN
        ERROR _ERR_ILLEGAL_FUNCTION_CALL ' duplicate key
    END IF
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value _BYTE.
SUB HashTable_InsertByte (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _BYTE)
    HashTable_Insert hashTable(), k, _MK$(_BYTE, v)
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value INTEGER.
SUB HashTable_InsertInteger (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS INTEGER)
    HashTable_Insert hashTable(), k, MKI$(v)
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value LONG.
SUB HashTable_InsertLong (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS LONG)
    HashTable_Insert hashTable(), k, MKL$(v)
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value SINGLE.
SUB HashTable_InsertSingle (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS SINGLE)
    HashTable_Insert hashTable(), k, MKS$(v)
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value DOUBLE.
SUB HashTable_InsertDouble (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS DOUBLE)
    HashTable_Insert hashTable(), k, MKD$(v)
END SUB

''' @brief Inserts a key-value pair into the hash table.
''' @param table The hash table to insert into.
''' @param k The key.
''' @param v The value _INTEGER64.
SUB HashTable_InsertInteger64 (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _INTEGER64)
    HashTable_Insert hashTable(), k, _MK$(_INTEGER64, v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value string.
SUB HashTable_Update (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS STRING)
    DIM idx AS _UNSIGNED LONG: idx = __HashTable_Hash(k, UBOUND(hashTable))

    IF hashTable(idx).U THEN
        IF hashTable(idx).K = k THEN
            ' Key already exists
            hashTable(idx).V = v ' allow overwrite
            EXIT SUB
        ELSE
            __HashTable_ResizeAndRehash hashTable()
            HashTable_Update hashTable(), k, v
            EXIT SUB
        END IF
    ELSE
        hashTable(idx).U = _TRUE
        hashTable(idx).K = k
        hashTable(idx).V = v
    END IF
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value _BYTE.
SUB HashTable_UpdateByte (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _BYTE)
    HashTable_Update hashTable(), k, _MK$(_BYTE, v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value INTEGER.
SUB HashTable_UpdateInteger (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS INTEGER)
    HashTable_Update hashTable(), k, MKI$(v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value LONG.
SUB HashTable_UpdateLong (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS LONG)
    HashTable_Update hashTable(), k, MKL$(v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value SINGLE.
SUB HashTable_UpdateSingle (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS SINGLE)
    HashTable_Update hashTable(), k, MKS$(v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value DOUBLE.
SUB HashTable_UpdateDouble (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS DOUBLE)
    HashTable_Update hashTable(), k, MKD$(v)
END SUB

''' @brief Updates an existing key or inserts it if not present.
''' @param table The hash table to update.
''' @param k The key.
''' @param v The value _INTEGER64.
SUB HashTable_UpdateInteger64 (hashTable() AS HashTableType, k AS _UNSIGNED LONG, v AS _INTEGER64)
    HashTable_Update hashTable(), k, _MK$(_INTEGER64, v)
END SUB

