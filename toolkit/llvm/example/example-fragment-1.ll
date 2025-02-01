loop_cond:                             ; Loop condition block
  %j = alloca i32, align 4             ; Allocate index variable
  %i_val = load i32, i32* %i, align 4  ; Load current value of i
  %cond = icmp slt i32 %i_val, %N      ; Compare i < N
  br i1 %cond, label %loop_body, label %loop_end

; debt:
;   label target: %loop_end
;   lanel from: loop_cond
;   arg input: %i
;   arg input: %N
;   arg input: Stack[-4 , align:4]
;   ouput (unconsumed):
;       %j
;
;   output: other possibles ones: EVERYTHING.
;      todo: hint for "keep using it". i.e. "clone" it. (dont' cut dead)
;      but consumed ones also may be aprt of "fanar-out!": "clean/del-except" closures (recurrent closure)
;  addresses:
;      PLACES:
;           input: ... (as mentioned above)
;      OFFSETS:
;           "Stack" ( implicit in `alloca`)
;      jump-addresses (code-block): target and from: (see "topology" below): adresses are IXED, except for the shift in all of above "contiguous" block-piece of code (all Ucode. LLVM UCode s are contiguous, hence, single-piece).
;           (FRAME BEGIN)
;              which, again, codincides with other two.
; topology:
;     1. input arrival / enter ()
;     1. (same): input enter (from begining)
;        they both coincide.
;     2. label %loop_body
;     3. label %loop_end
;
;
; Not used: align patterns, effective (used) sizes ( i32, but not all is used?)
;    todo: specify that.
;    Maybe I will need my own LLVM IR?
