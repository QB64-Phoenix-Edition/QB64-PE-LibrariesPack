// +---------------+---------------------------------------------------+
// | ###### ###### |     .--. .         .-.                            |
// | ##  ## ##   # |     |   )|        (   ) o                         |
// | ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
// | ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
// | ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
// | ##     ##   # |                            ._.'                   |
// | ##     ###### |  Sources & Documents placed in the Public Domain. |
// +---------------+---------------------------------------------------+
// |                                                                   |
// | === qbtime.h ===                                                  |
// |                                                                   |
// | == Some low level support functions for routines in qbtime.bm.    |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_TIME_H // include only once
#define RSQB_TIME_H

#include "../QB-StdArg/qbstdarg.h"
using rsqbstdarg::MakeCString;

namespace rsqbtime {

// --- Formatted write of current date and time, using the given format
// --- template, to a fixed size string buffer.
// ---------------------------------------------------------------------
ptrszint CurrentTimeToBuffer(ptrszint cFmtStr) {
    char *cStr = (char*) MakeCString(0, 1024); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    time_t curr; time(&curr); // get current time
    int32_t num = strftime(cStr, 1024, (const char*) cFmtStr, localtime(&curr)); // format to buffer
    return (ptrszint) cStr;
}

// --- Formatted write of given date and time, using the given format
// --- template, to a fixed size string buffer.
// ---------------------------------------------------------------------
ptrszint GivenTimeToBuffer(ptrszint cFmtStr, const char *qbArgStr) {
    char *cStr = (char*) MakeCString(0, 1024); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    if (-1 != mktime((struct tm*) qbArgStr)) { // adjust given tm structure
        int32_t num = strftime(cStr, 1024, (const char*) cFmtStr, (const struct tm*) qbArgStr); // format to buffer
    }
    return (ptrszint) cStr;
}

} // namespace

#endif // RSQB_TIME_H

