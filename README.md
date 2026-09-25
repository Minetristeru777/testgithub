# Orange Pi Zero LTS bare-metal ARMv7

Мінімальний bare-metal проєкт для Allwinner H2+ (ARM Cortex-A7). Startup-код
встановлює стек, очищає BSS, викликає `main()` і переходить у нескінченний цикл.

## Збірка

Потрібні `clang`, `lld` і `llvm-objcopy` або GNU ARM toolchain (`arm-none-eabi-gcc`
та `arm-none-eabi-objcopy`). Для GNU toolchain можна вказати префікс:

```sh
make CROSS_COMPILE=arm-none-eabi-
```

Результати з'являються у `build/orangeuefi.elf` та `build/orangeuefi.bin`.

Код ще не перевірений на фізичній Orange Pi Zero LTS.
