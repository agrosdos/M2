// (c) 1997 Michael E. Stillman

// This stuff would not be necessary if exceptions worked well,
// unfortunately, there are internal errors so that they fail
// at least in the presence of template code (even in version 2.7.2).
// So, we use the following simple, if unpleasant, scheme.
//
// Upon finding an error, call ERROR any number of times.  Each time,
// The message is added to the end (but, it won't write over the end of
// the buffer).
//
// Then, it is unfortunately necessary to check whether an error has
// occured, using 'error'.
//
// Finally, the error flag is cleared upon giving control back to the front end.

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include "error.h"

#define MAXERROR 200
static int iserror = 0;
static char errmsg[MAXERROR] = {'\0'};

#if 0
void ERROR(char *s,...)
{
  va_list ap;
  if (iserror) INTERNAL_ERROR("ERROR called a second time, first message was: '%s'", errmsg);
  va_start(ap,s);
  iserror = 1;
  vsprintf(errmsg,s,ap);
  va_end(ap);
}
#endif

void ERROR(char *s,...)
{
  va_list ap;
  if (iserror++) return;
  va_start(ap,s);
  vsprintf(errmsg,s,ap);
  va_end(ap);
}

void INTERNAL_ERROR(char *s,...)
{
  char buf[MAXERROR];
  buf[0] = 0;
  va_list ap;
  va_start(ap,s);
  vsprintf(buf,s,ap);
  va_end(ap);
  fprintf(stderr, "--internal error: %s\n", buf);
  /* exit(1); */
}

int error()
{
  return iserror;
}

char *error_message()
{
#ifndef NDEBUG
  if (iserror > 1)
    fprintf(stderr, "error count is %d\n", iserror);
#endif
  iserror = 0;
  return errmsg;
}

/*
// Local Variables:
// compile-command: "make -C $M2BUILDDIR/Macaulay2/e "
// End:
*/
