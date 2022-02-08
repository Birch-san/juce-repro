Example of cross-compiling a JUCE audio plugin (on Linux, targeting Windows, using llvm-mingw).


```bash
docker build --tag=juce-repro .
```

Build fails in JUCE code:

```
In file included from /linux_native/include/JUCE-6.1.5/modules/juce_core/juce_core.h:351:
/linux_native/include/JUCE-6.1.5/modules/juce_core/native/juce_win32_ComSmartPtr.h:178:22: error: use of undeclared identifier '__mingw_uuidof'
        if (refId == __uuidof (IUnknown))
                     ^
/opt/llvm-mingw/x86_64-w64-mingw32/include/_mingw.h:564:24: note: expanded from macro '__uuidof'
#define __uuidof(type) __mingw_uuidof<__typeof(type)>()
```

Seems related to this issue I raised against JUCE 6.1.3:  
https://github.com/juce-framework/JUCE/issues/985