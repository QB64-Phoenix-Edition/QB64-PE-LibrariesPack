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
// | === qbstdarg.h ===                                                |
// |                                                                   |
// | == Some low level support functions for routines in qbstdarg.bm.  |
// |                                                                   |
// +-------------------------------------------------------------------+
// | Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
// | Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
// | any questions or suggestions. Thanx for your interest in my work. |
// +-------------------------------------------------------------------+

#ifndef RSQB_STDARG_H // include only once
#define RSQB_STDARG_H

namespace rsqbstdarg {

int16_t  fcdFlag = 0;   // first call done flag
ptrszint cMemBrain = 0; // CString memory brain (list anchor)

void FreeCString(ptrszint cStr); // fwd ref

// --- Internal function never called from QB64 level, it's linked into the
// --- program's exit procedure to automatically free all remaining CStrings
// --- right before the program is finally terminated.
// ---------------------------------------------------------------------
void ExitCStringCleanup (void)
{
    while (cMemBrain) {
        FreeCString(cMemBrain + ptrsz); // memptr + linkptr = strptr
    }
}

// --- Create a independent copy of the given QB64 string, also evaluate
// --- the usual C/C++ escape sequences and octal or hex escaped characters.
// ---------------------------------------------------------------------
ptrszint MakeCString(char *qbStr, int32_t qbStrLen) {
    if (!fcdFlag) {
        atexit(ExitCStringCleanup); // init auto-cleanup on 1st call
        fcdFlag = -1;
    }
    ptrszint *cMemPtr = (ptrszint*) malloc(qbStrLen + ptrsz + 1); // + linkptrsz & zero termination
    *cMemPtr = cMemBrain; cMemBrain = (ptrszint) cMemPtr++; // memptr + linkptrsz = strptr (cMemPtr++)
    char *cStr = (char*) cMemPtr;
    if (qbStr != 0) {
        char *seq; int32_t len; // sequence temporaries
        for (int16_t esc = 0; qbStrLen; qbStrLen--) {
            unsigned char chr = *qbStr++;
            if (chr == '\\' && !esc) {esc = -1;}
            else if (esc) {
                esc = 0; len = 0;
                switch (chr) {
                    case 'a': {*cStr++ = '\a'; seq = (char*)"\\a"; break;}
                    case 'b': {*cStr++ = '\b'; seq = (char*)"\\b"; break;}
                    case 't': {*cStr++ = '\t'; seq = (char*)"\\t"; break;}
                    case 'n': {*cStr++ = '\n'; seq = (char*)"\\n"; break;}
                    case 'v': {*cStr++ = '\v'; seq = (char*)"\\v"; break;}
                    case 'f': {*cStr++ = '\f'; seq = (char*)"\\f"; break;}
                    case 'r': {*cStr++ = '\r'; seq = (char*)"\\r"; break;}
                    case 'e': {*cStr++ = '\e'; seq = (char*)"\\e"; break;}
                    case '\"': {*cStr++ = '\"'; seq = (char*)"\\\x22"; break;}
                    case '\'': {*cStr++ = '\''; seq = (char*)"\\'"; break;}
                    case '?': {*cStr++ = '\?'; seq = (char*)"\\?"; break;}
                    case '\\': {*cStr++ = '\\'; seq = (char*)"\\\\"; break;}
                    case '0': case '1': case '2': case '3': case 'x': case 'X': {
                        char tmp = qbStr[2]; qbStr[2] = '\0'; char *eptr;
                        if (chr == 'x' || chr == 'X') {*cStr++ = strtoul(qbStr, &eptr, 16);} // hex value
                        else {*cStr++ = strtoul(&qbStr[-1], &eptr, 8);} // octal value
                        qbStr[2] = tmp; len = eptr - qbStr; qbStrLen -= len; qbStr = eptr;
                        seq = 0; // oct/hex indicator for debug output
                        break;
                    }
                    default: {*cStr++ = chr; break;} // no valid sequence (= literal)
                }
            }
            else {*cStr++ = chr;} // regular literal char
        }
    }
    *cStr = '\0'; // zero terminate
    return (ptrszint) cMemPtr;
}

// --- Return the length (without zero termination) of the given CString
// --- copy previously made with MakeCString().
// ---------------------------------------------------------------------
int32_t LenCString(ptrszint cStr) {
    if (!fcdFlag) {return 0;} // nothing there yet
    int32_t len = strlen((const char*) cStr);
    return len;
}

// --- Return the given CString copy, previously made with MakeCString(),
// --- back into a regular QB64 string.
// ---------------------------------------------------------------------
const char *ReadCString(ptrszint cStr) {
    if (!fcdFlag) {return "";} // nothing there yet
    return (const char*) cStr;
}

// --- Free the given CString copy made with MakeCString().
// ---------------------------------------------------------------------
void FreeCString(ptrszint cStr) {
    if (!fcdFlag) {return;} // nothing to free yet
    ptrszint *cMemPtr = (ptrszint*) cStr; cMemPtr--; // strptr - linkptrsz = memptr (cMemPtr--)
    ptrszint *cMemPre = &cMemBrain;
    ptrszint *cMemTmp = (ptrszint*) cMemBrain;
    while (cMemTmp && (cMemTmp != cMemPtr)) { // verify given pointer
        cMemPre = cMemTmp;
        cMemTmp = (ptrszint*) *cMemTmp;
    }
    if (cMemTmp) { // if valid entry found, then unlink & free
        *cMemPre = *cMemTmp;
        free((void*) cMemTmp);
    }
}

// --- Helper function to convert _OFFSET into _INTEGER64, which is not
// --- possible on the QB64 language level.
// ---------------------------------------------------------------------
int64_t OffToInt(ptrszint offs) {
    return (int64_t) offs;
}

} // namespace

#endif // RSQB_STDARG_H

