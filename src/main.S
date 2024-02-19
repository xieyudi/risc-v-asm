.option rvc
.global main
.extern puts

.section .text
# int main(int argc, char *argv[])
main:
  # create stackframe and save ra and fp
  addi  sp, sp, -16
  sd  ra, 8(sp)
  sd  fp, 0(sp)
  addi  fp, sp, 16

  # puts("hello world");
  la a0, s_hello_world
  jal  ra, puts

  li  a0,0

  # restore ra and fp and free stackframe
  ld  ra, 8(sp)
  ld  fp, 0(sp)
  addi  sp, sp, 16
  ret

.section .rodata
s_hello_world:
  .asciz "hello world"
