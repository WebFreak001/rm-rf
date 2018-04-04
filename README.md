# rm-rf

This is identical to rmdirRecurse on posix but removes readonly bits on windows.

```d
import rm.rf;

rmdirRecurseForce("path/to/my/folder");
```
