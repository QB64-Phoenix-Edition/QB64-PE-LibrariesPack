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
// | === qbstdio.h ===                                                 |
// |                                                                   |
// | == Some low level support functions for routines in qbstdio.bm.   |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_STDIO_H // include only once
#define RSQB_STDIO_H

#include "../QB-StdArg/qbstdarg.h"
using rsqbstdarg::MakeCString;

namespace rsqbstdio {

// --- Formatted write of given variable arguments, using the given format
// --- template, to auto-sized string buffer.
// ---------------------------------------------------------------------
ptrszint FormatToBuffer(ptrszint cFmtStr, const char *qbArgStr) {
    int32_t num = vsnprintf(0, 0, (const char*) cFmtStr, (va_list) qbArgStr); // simulate to get buffer size
    char *cStr = (char*) MakeCString(0, num); // create output buffer
    cStr[0] = '\0'; // for safety, in case nothing is written
    vsprintf(cStr, (const char*) cFmtStr, (va_list) qbArgStr); // format to buffer
    return (ptrszint) cStr;
}

} // namespace

#endif // RSQB_STDIO_H

