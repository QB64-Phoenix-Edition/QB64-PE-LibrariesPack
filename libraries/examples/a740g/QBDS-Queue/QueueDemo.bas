$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Queue'

REDIM myQueue(0) AS Queue

Queue_Initialize myQueue()
PRINT "Queue initialized"
PRINT "Is initialized: "; _IIF(Queue_IsInitialized(myQueue()), "True", "False")
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT "Capacity: "; Queue_GetCapacity(myQueue())
PRINT

PRINT "Enqueuing items..."
Queue_EnqueueString myQueue(), "Apple"
Queue_EnqueueInteger myQueue(), 42
Queue_EnqueueString myQueue(), "Banana"
Queue_EnqueueLong myQueue(), 123456789
PRINT "Items enqueued"
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT "Capacity: "; Queue_GetCapacity(myQueue())
PRINT

PRINT "Peeking at the front of the queue..."
PRINT "Peek (String): "; Queue_PeekString(myQueue())
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Dequeuing items..."
PRINT "Dequeue (String): "; Queue_DequeueString(myQueue())
PRINT "Dequeue (Integer): "; Queue_DequeueInteger(myQueue())
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Clearing the queue..."
Queue_Clear myQueue()
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT "Capacity: "; Queue_GetCapacity(myQueue())
PRINT

PRINT "Enqueuing more items..."
Queue_EnqueueSingle myQueue(), 3.14
Queue_EnqueueDouble myQueue(), 1.23456789012345
PRINT "Items enqueued"
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Dequeuing remaining items..."
PRINT "Dequeue (Single): "; Queue_DequeueSingle(myQueue())
PRINT "Dequeue (Double): "; Queue_DequeueDouble(myQueue())
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Freeing the queue..."
Queue_Free myQueue()
PRINT "Is initialized: "; _IIF(Queue_IsInitialized(myQueue()), "True", "False")

