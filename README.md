Example of cross-compiling a JUCE audio plugin (on Linux, targeting Windows, using llvm-mingw).


```bash
docker build .
```

This repository reproduces the problem that occurs when attempting to compile on [llvm-mingw 20220209](https://github.com/mstorsjo/llvm-mingw/releases/tag/20220209), namely a clash of defines on `juce_gui_basics.cpp`:

```
In file included from /linux_native/include/JUCE-6.1.5/modules/juce_gui_basics/juce_gui_basics.cpp:309:
/linux_native/include/JUCE-6.1.5/modules/juce_gui_basics/native/accessibility/juce_win32_ComInterfaces.h:123:12: error: expected unqualified-id
const long UIA_InvokePatternId = 10000;
           ^
/opt/llvm-mingw/x86_64-w64-mingw32/include/uiautomationclient.h:34:30: note: expanded from macro 'UIA_InvokePatternId'
#define UIA_InvokePatternId (10000)
```

JUCE tries to [declare a constant](https://github.com/juce-framework/JUCE/blob/53b04877c6ebc7ef3cb42e84cb11a48e0cf809b5/modules/juce_gui_basics/native/accessibility/juce_win32_ComInterfaces.h#L123-L174):    

```c++
const long UIA_InvokePatternId = 10000;
```

But the token `UIA_InvokePatternId` [already exists as a MinGW macro](https://github.com/mingw-w64/mingw-w64/blob/2f6d8b806107cc8d543de2c9415a328a780a8267/mingw-w64-headers/include/uiautomationclient.h#L34-L450), and expands to `(10000)`, making the statement:

```c++
const long (10000) = 10000;
```

If we revert to [llvm-mingw 20211002](https://github.com/mstorsjo/llvm-mingw/releases/tag/20211002), it compiles just fine:

```bash
docker build --build-arg LLVM_MINGW_VER=20211002 .
```