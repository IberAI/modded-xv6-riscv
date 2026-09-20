#include "kernel/types.h"
#include "user/user.h"


int
main(int argc, char * argv[])
{
  uint64 empty = mempty();
  printf(1, "Here is the Bytes of Physical empty memory %u\n", empty);
  exit(0);
}
