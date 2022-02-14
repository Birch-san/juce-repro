# Cross-compiling JUCE via llvm-mingw

This repository showcases how to cross-compiling a JUCE audio plugin (on Linux, targeting Windows, using llvm-mingw).

By varying the build arguments, we can reproduce:

- Working build
- Failing build ([#1028](https://github.com/juce-framework/JUCE/issues/1028))
- Failing build ([#1029](https://github.com/juce-framework/JUCE/issues/1029))

## Working build

If we revert to [llvm-mingw 20211002](https://github.com/mstorsjo/llvm-mingw/releases/tag/20211002), and target x86_64, it compiles just fine:

```bash
docker build --build-arg LLVM_MINGW_VER=20211002 .
```

## Failing build ([#1028](https://github.com/juce-framework/JUCE/issues/1028))

We can reproduce the failure to compile with recent [llvm-mingw 20220209](https://github.com/mstorsjo/llvm-mingw/releases/tag/20220209) (most recent release):


```bash
docker build .
```

i.e. a clash of defines on `juce_gui_basics.cpp`:

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

## Failing build ([#1029](https://github.com/juce-framework/JUCE/issues/1029))

[llvm-mingw 20211002](https://github.com/mstorsjo/llvm-mingw/releases/tag/20211002) is known-good, but JUCE 6.1.5 encounters compile failure if we target x86 architecture:

```bash
docker build --build-arg LLVM_MINGW_VER=20211002 --build-arg XARCH=i686 .
```

```
In file included from /linux_native/include/JUCE-6.1.5/modules/juce_gui_basics/juce_gui_basics.cpp:309:
/linux_native/include/JUCE-6.1.5/modules/juce_gui_basics/native/accessibility/juce_win32_ComInterfaces.h:179:1: error: class template specialization of 'UUIDGetter' not in a namespace enclosing 'juce'
JUCE_COMCLASS (IRawElementProviderFragmentRoot, "620ce2a5-ab8f-40a9-86cb-de3c75599b58") : public IUnknown
^
/linux_native/include/JUCE-6.1.5/modules/juce_core/native/juce_win32_ComSmartPtr.h:45:5: note: expanded from macro 'JUCE_COMCLASS'
    JUCE_DECLARE_UUID_GETTER (name, guid) \
    ^
/linux_native/include/JUCE-6.1.5/modules/juce_core/native/juce_win32_ComSmartPtr.h:41:24: note: expanded from macro 'JUCE_DECLARE_UUID_GETTER'
    template <> struct UUIDGetter<name> { static CLSID get()  { return uuidFromString (uuid); } };
                       ^
/linux_native/include/JUCE-6.1.5/modules/juce_core/native/juce_win32_ComSmartPtr.h:31:34: note: explicitly specialized declaration is here
 template <typename Type> struct UUIDGetter { static CLSID get() { jassertfalse; return {}; } };
                                 ^
```