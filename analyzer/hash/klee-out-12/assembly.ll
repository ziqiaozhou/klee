; ModuleID = 'hash.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"key\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str2 = private unnamed_addr constant [13 x i8] c"result alert\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"result=\00", align 1
@.str4 = private unnamed_addr constant [7 x i8] c"result\00", align 1
@.str5 = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str16 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str27 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1
@.str38 = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str25 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1
@.str6 = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private unnamed_addr constant [14 x i8] c"invalid range\00", align 1
@.str28 = private unnamed_addr constant [5 x i8] c"user\00", align 1

; Function Attrs: nounwind uwtable
define i8* @hash(i8* %result, i8* %key, i8* %data, i32 %n, i32 %m) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %l = alloca i32, align 4
  %onebit = alloca i8, align 1
  %aAndy = alloca i8, align 1
  %axory = alloca i8, align 1
  %aAndy0 = alloca i8, align 1
  %axory1 = alloca i8, align 1
  %result_i_ptr = alloca i8*, align 8
  %y = alloca i8, align 1
  %a = alloca i8, align 1
  store i8* %result, i8** %2, align 8
  store i8* %key, i8** %3, align 8
  store i8* %data, i8** %4, align 8
  store i32 %n, i32* %5, align 4
  store i32 %m, i32* %6, align 4
  %7 = load i32* %5, align 4, !dbg !126
  %8 = icmp sle i32 %7, 0, !dbg !126
  %9 = load i8** %4, align 8
  %10 = icmp eq i8* %9, null, !dbg !128
  %or.cond = or i1 %8, %10, !dbg !126
  br i1 %or.cond, label %11, label %12, !dbg !126

; <label>:11                                      ; preds = %0
  store i8* null, i8** %1, !dbg !130
  br label %105, !dbg !130

; <label>:12                                      ; preds = %0
  store i32 0, i32* %i, align 4, !dbg !133
  br label %13, !dbg !133

; <label>:13                                      ; preds = %102, %12
  %14 = load i32* %i, align 4, !dbg !135
  %15 = load i32* %6, align 4, !dbg !135
  %16 = icmp slt i32 %14, %15, !dbg !135
  br i1 %16, label %17, label %105, !dbg !135

; <label>:17                                      ; preds = %13
  %18 = load i32* %i, align 4, !dbg !138
  %19 = sext i32 %18 to i64, !dbg !138
  %20 = load i8** %2, align 8, !dbg !138
  %21 = getelementptr inbounds i8* %20, i64 %19, !dbg !138
  store i8* %21, i8** %result_i_ptr, align 8, !dbg !138
  store i32 0, i32* %k, align 4, !dbg !140
  br label %22, !dbg !140

; <label>:22                                      ; preds = %90, %17
  %23 = load i32* %k, align 4, !dbg !142
  %24 = icmp slt i32 %23, 8, !dbg !142
  br i1 %24, label %25, label %102, !dbg !142

; <label>:25                                      ; preds = %22
  %26 = load i32* %k, align 4, !dbg !145
  %27 = load i32* %i, align 4, !dbg !145
  %28 = mul nsw i32 8, %27, !dbg !145
  %29 = add nsw i32 %26, %28, !dbg !145
  %30 = add nsw i32 %29, 0, !dbg !145
  %31 = sext i32 %30 to i64, !dbg !145
  %32 = load i8** %3, align 8, !dbg !145
  %33 = getelementptr inbounds i8* %32, i64 %31, !dbg !145
  %34 = load i8* %33, align 1, !dbg !145
  %35 = sext i8 %34 to i32, !dbg !145
  %36 = and i32 1, %35, !dbg !145
  %37 = load i8** %4, align 8, !dbg !145
  %38 = getelementptr inbounds i8* %37, i64 0, !dbg !145
  %39 = load i8* %38, align 1, !dbg !145
  %40 = sext i8 %39 to i32, !dbg !145
  %41 = and i32 %36, %40, !dbg !145
  %42 = trunc i32 %41 to i8, !dbg !145
  store i8 %42, i8* %axory, align 1, !dbg !145
  store i32 0, i32* %l, align 4, !dbg !147
  br label %43, !dbg !147

; <label>:43                                      ; preds = %87, %25
  %44 = load i32* %l, align 4, !dbg !149
  %45 = load i32* %5, align 4, !dbg !149
  %46 = icmp slt i32 %44, %45, !dbg !149
  br i1 %46, label %47, label %90, !dbg !149

; <label>:47                                      ; preds = %43
  %48 = load i32* %l, align 4, !dbg !152
  %49 = sext i32 %48 to i64, !dbg !152
  %50 = load i8** %4, align 8, !dbg !152
  %51 = getelementptr inbounds i8* %50, i64 %49, !dbg !152
  %52 = load i8* %51, align 1, !dbg !152
  store i8 %52, i8* %y, align 1, !dbg !152
  %53 = load i32* %k, align 4, !dbg !154
  %54 = load i32* %i, align 4, !dbg !154
  %55 = mul nsw i32 8, %54, !dbg !154
  %56 = add nsw i32 %53, %55, !dbg !154
  %57 = mul nsw i32 %56, 4, !dbg !154
  %58 = load i32* %l, align 4, !dbg !154
  %59 = add nsw i32 %57, %58, !dbg !154
  %60 = sext i32 %59 to i64, !dbg !154
  %61 = load i8** %3, align 8, !dbg !154
  %62 = getelementptr inbounds i8* %61, i64 %60, !dbg !154
  %63 = load i8* %62, align 1, !dbg !154
  store i8 %63, i8* %a, align 1, !dbg !154
  %64 = load i8* %a, align 1, !dbg !155
  %65 = zext i8 %64 to i32, !dbg !155
  %66 = load i8* %y, align 1, !dbg !155
  %67 = zext i8 %66 to i32, !dbg !155
  %68 = and i32 %65, %67, !dbg !155
  %69 = trunc i32 %68 to i8, !dbg !155
  store i8 %69, i8* %aAndy, align 1, !dbg !155
  store i32 0, i32* %l, align 4, !dbg !156
  br label %70, !dbg !156

; <label>:70                                      ; preds = %73, %47
  %71 = load i32* %l, align 4, !dbg !158
  %72 = icmp slt i32 %71, 8, !dbg !158
  br i1 %72, label %73, label %87, !dbg !158

; <label>:73                                      ; preds = %70
  %74 = load i8* %aAndy, align 1, !dbg !161
  %75 = zext i8 %74 to i32, !dbg !161
  %76 = and i32 %75, 1, !dbg !161
  %77 = load i8* %axory, align 1, !dbg !161
  %78 = zext i8 %77 to i32, !dbg !161
  %79 = xor i32 %78, %76, !dbg !161
  %80 = trunc i32 %79 to i8, !dbg !161
  store i8 %80, i8* %axory, align 1, !dbg !161
  %81 = load i8* %aAndy, align 1, !dbg !163
  %82 = zext i8 %81 to i32, !dbg !163
  %int_cast_to_i64 = zext i32 1 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i64), !dbg !163
  %83 = ashr i32 %82, 1, !dbg !163
  %84 = trunc i32 %83 to i8, !dbg !163
  store i8 %84, i8* %aAndy, align 1, !dbg !163
  %85 = load i32* %l, align 4, !dbg !164
  %86 = add nsw i32 %85, 1, !dbg !164
  store i32 %86, i32* %l, align 4, !dbg !164
  br label %70, !dbg !164

; <label>:87                                      ; preds = %70
  %88 = load i32* %l, align 4, !dbg !165
  %89 = add nsw i32 %88, 1, !dbg !165
  store i32 %89, i32* %l, align 4, !dbg !165
  br label %43, !dbg !165

; <label>:90                                      ; preds = %43
  %91 = load i8* %axory, align 1, !dbg !166
  %92 = zext i8 %91 to i32, !dbg !166
  %93 = load i32* %i, align 4, !dbg !166
  %int_cast_to_i641 = zext i32 %93 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i641), !dbg !166
  %94 = shl i32 %92, %93, !dbg !166
  %95 = load i8** %result_i_ptr, align 8, !dbg !166
  %96 = load i8* %95, align 1, !dbg !166
  %97 = zext i8 %96 to i32, !dbg !166
  %98 = or i32 %97, %94, !dbg !166
  %99 = trunc i32 %98 to i8, !dbg !166
  store i8 %99, i8* %95, align 1, !dbg !166
  %100 = load i32* %k, align 4, !dbg !167
  %101 = add nsw i32 %100, 1, !dbg !167
  store i32 %101, i32* %k, align 4, !dbg !167
  br label %22, !dbg !167

; <label>:102                                     ; preds = %22
  %103 = load i32* %i, align 4, !dbg !168
  %104 = add nsw i32 %103, 1, !dbg !168
  store i32 %104, i32* %i, align 4, !dbg !168
  br label %13, !dbg !168

; <label>:105                                     ; preds = %13, %11
  %106 = load i8** %1, !dbg !169
  ret i8* %106, !dbg !169
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %key = alloca [96 x i8], align 16
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  %data = alloca [4 x i8], align 1
  %result = alloca i64, align 8
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 4, i32* %n, align 4, !dbg !170
  store i32 3, i32* %m, align 4, !dbg !170
  store i32 178956629, i32* %x, align 4, !dbg !171
  store i32 0, i32* %i, align 4, !dbg !172
  br label %4, !dbg !172

; <label>:4                                       ; preds = %7, %0
  %5 = load i32* %i, align 4, !dbg !174
  %6 = icmp slt i32 %5, 24, !dbg !174
  br i1 %6, label %7, label %16, !dbg !174

; <label>:7                                       ; preds = %4
  %8 = load i32* %i, align 4, !dbg !177
  %9 = mul nsw i32 %8, 4, !dbg !177
  %10 = sext i32 %9 to i64, !dbg !177
  %11 = getelementptr inbounds [96 x i8]* %key, i32 0, i64 %10, !dbg !177
  %12 = bitcast i32* %x to i8*, !dbg !177
  %13 = call i8* @memcpy(i8* %11, i8* %12, i64 4)
  %14 = load i32* %i, align 4, !dbg !179
  %15 = add nsw i32 %14, 1, !dbg !179
  store i32 %15, i32* %i, align 4, !dbg !179
  br label %4, !dbg !179

; <label>:16                                      ; preds = %4
  %17 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !180
  %18 = call i32 (i8*, i32, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i8*, i32, i8*, ...)*)(i8* %17, i32 96, i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0)), !dbg !180
  %19 = getelementptr inbounds [4 x i8]* %data, i32 0, i32 0, !dbg !181
  %20 = call i32 (i8*, i32, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i8*, i32, i8*, ...)*)(i8* %19, i32 4, i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0)), !dbg !181
  %21 = bitcast i64* %result to i8*, !dbg !182
  %22 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !182
  %23 = getelementptr inbounds [4 x i8]* %data, i32 0, i32 0, !dbg !182
  %24 = load i32* %n, align 4, !dbg !182
  %25 = load i32* %m, align 4, !dbg !182
  %26 = call i8* @hash(i8* %21, i8* %22, i8* %23, i32 %24, i32 %25), !dbg !182
  %27 = load i64* %result, align 8, !dbg !183
  %28 = icmp ult i64 %27, 10000, !dbg !183
  %29 = load i64* %result, align 8
  %30 = icmp ugt i64 %29, 100, !dbg !185
  %or.cond = and i1 %28, %30, !dbg !183
  br i1 %or.cond, label %31, label %33, !dbg !183

; <label>:31                                      ; preds = %16
  %32 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str2, i32 0, i32 0)), !dbg !187
  store i32 0, i32* %1, !dbg !189
  br label %38, !dbg !189

; <label>:33                                      ; preds = %16
  %34 = load i64* %result, align 8, !dbg !190
  %35 = call i32 (i8*, i64, ...)* bitcast (i32 (...)* @klee_make_observable to i32 (i8*, i64, ...)*)(i8* getelementptr inbounds ([8 x i8]* @.str3, i32 0, i32 0), i64 %34), !dbg !190
  %36 = load i64* %result, align 8, !dbg !191
  %37 = call i32 (i8*, i64, ...)* bitcast (i32 (...)* @klee_print_expr to i32 (i8*, i64, ...)*)(i8* getelementptr inbounds ([7 x i8]* @.str4, i32 0, i32 0), i64 %36), !dbg !191
  store i32 1, i32* %1, !dbg !192
  br label %38, !dbg !192

; <label>:38                                      ; preds = %33, %31
  %39 = load i32* %1, !dbg !193
  ret i32 %39, !dbg !193
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

declare i32 @klee_make_symbolic(...) #3

declare i32 @printf(i8*, ...) #3

declare i32 @klee_make_observable(...) #3

declare i32 @klee_print_expr(...) #3

; Function Attrs: nounwind ssp uwtable
define void @klee_div_zero_check(i64 %z) #4 {
  %1 = icmp eq i64 %z, 0, !dbg !194
  br i1 %1, label %2, label %3, !dbg !194

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str5, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str16, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str27, i64 0, i64 0)) #7, !dbg !196
  unreachable, !dbg !196

; <label>:3                                       ; preds = %0
  ret void, !dbg !197
}

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #5

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #1

; Function Attrs: nounwind ssp uwtable
define i32 @klee_int(i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = bitcast i32* %x to i8*, !dbg !198
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %1, i64 4, i8* %name) #8, !dbg !198
  %2 = load i32* %x, align 4, !dbg !199, !tbaa !200
  ret i32 %2, !dbg !199
}

; Function Attrs: nounwind ssp uwtable
define void @klee_overshift_check(i64 %bitWidth, i64 %shift) #4 {
  %1 = icmp ult i64 %shift, %bitWidth, !dbg !204
  br i1 %1, label %3, label %2, !dbg !204

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str38, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) #7, !dbg !206
  unreachable, !dbg !206

; <label>:3                                       ; preds = %0
  ret void, !dbg !208
}

; Function Attrs: nounwind ssp uwtable
define i32 @klee_range(i32 %start, i32 %end, i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = icmp slt i32 %start, %end, !dbg !209
  br i1 %1, label %3, label %2, !dbg !209

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str6, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) #7, !dbg !211
  unreachable, !dbg !211

; <label>:3                                       ; preds = %0
  %4 = add nsw i32 %start, 1, !dbg !212
  %5 = icmp eq i32 %4, %end, !dbg !212
  br i1 %5, label %21, label %6, !dbg !212

; <label>:6                                       ; preds = %3
  %7 = bitcast i32* %x to i8*, !dbg !214
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %7, i64 4, i8* %name) #8, !dbg !214
  %8 = icmp eq i32 %start, 0, !dbg !216
  %9 = load i32* %x, align 4, !dbg !218, !tbaa !200
  br i1 %8, label %10, label %13, !dbg !216

; <label>:10                                      ; preds = %6
  %11 = icmp ult i32 %9, %end, !dbg !218
  %12 = zext i1 %11 to i64, !dbg !218
  call void @klee_assume(i64 %12) #8, !dbg !218
  br label %19, !dbg !220

; <label>:13                                      ; preds = %6
  %14 = icmp sge i32 %9, %start, !dbg !221
  %15 = zext i1 %14 to i64, !dbg !221
  call void @klee_assume(i64 %15) #8, !dbg !221
  %16 = load i32* %x, align 4, !dbg !223, !tbaa !200
  %17 = icmp slt i32 %16, %end, !dbg !223
  %18 = zext i1 %17 to i64, !dbg !223
  call void @klee_assume(i64 %18) #8, !dbg !223
  br label %19

; <label>:19                                      ; preds = %13, %10
  %20 = load i32* %x, align 4, !dbg !224, !tbaa !200
  br label %21, !dbg !224

; <label>:21                                      ; preds = %19, %3
  %.0 = phi i32 [ %20, %19 ], [ %start, %3 ]
  ret i32 %.0, !dbg !225
}

declare void @klee_assume(i64) #6

; Function Attrs: nounwind ssp uwtable
define weak i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !226
  br i1 %1, label %._crit_edge, label %overflow.checked, !dbg !226

overflow.checked:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %overflow.checked
  %scevgep4 = getelementptr i8* %srcaddr, i64 %2
  %bound0 = icmp uge i8* %scevgep4, %destaddr
  %scevgep = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep, %srcaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end7 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body.preheader

vector.body.preheader:                            ; preds = %vector.memcheck
  %3 = add i64 %len, -32
  %4 = lshr i64 %3, 5
  %5 = add nuw nsw i64 %4, 1
  %xtraiter309 = and i64 %5, 1
  %lcmp.mod310 = icmp eq i64 %xtraiter309, 0
  br i1 %lcmp.mod310, label %vector.body.preheader.split, label %vector.body.unr

vector.body.unr:                                  ; preds = %vector.body.preheader
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !228
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !228, !tbaa !229
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !228
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !228
  %wide.load202.unr = load <16 x i8>* %8, align 1, !dbg !228, !tbaa !229
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !228, !tbaa !229
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !228
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load202.unr, <16 x i8>* %11, align 1, !dbg !228, !tbaa !229
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep105 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !228
  %wide.load = load <16 x i8>* %13, align 1, !dbg !228, !tbaa !229
  %next.gep.sum281 = or i64 %index, 16, !dbg !228
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum281, !dbg !228
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !228
  %wide.load202 = load <16 x i8>* %15, align 1, !dbg !228, !tbaa !229
  %16 = bitcast i8* %next.gep105 to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !228, !tbaa !229
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum281, !dbg !228
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load202, <16 x i8>* %18, align 1, !dbg !228, !tbaa !229
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep105.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !228
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !228, !tbaa !229
  %next.gep.sum281.1 = or i64 %index.next, 16, !dbg !228
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum281.1, !dbg !228
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !228
  %wide.load202.1 = load <16 x i8>* %21, align 1, !dbg !228, !tbaa !229
  %22 = bitcast i8* %next.gep105.1 to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !228, !tbaa !229
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum281.1, !dbg !228
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !228
  store <16 x i8> %wide.load202.1, <16 x i8>* %24, align 1, !dbg !228, !tbaa !229
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !230

middle.block:                                     ; preds = %vector.body, %vector.body.preheader.split, %vector.memcheck, %overflow.checked
  %resume.val = phi i8* [ %srcaddr, %overflow.checked ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body.preheader.split ], [ %ptr.ind.end, %vector.body ]
  %resume.val5 = phi i8* [ %destaddr, %overflow.checked ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end7, %vector.body.preheader.split ], [ %ptr.ind.end7, %vector.body ]
  %resume.val8 = phi i64 [ %len, %overflow.checked ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body.preheader.split ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %overflow.checked ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body.preheader.split ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %middle.block
  %xtraiter = and i64 %resume.val8, 3
  %lcmp.mod = icmp ne i64 %xtraiter, 0
  %lcmp.overflow = icmp eq i64 %resume.val8, 0
  %lcmp.or = or i1 %lcmp.overflow, %lcmp.mod
  br i1 %lcmp.or, label %unr.cmp304, label %.lr.ph.preheader.split

unr.cmp304:                                       ; preds = %.lr.ph.preheader
  switch i64 %xtraiter, label %.lr.ph.unr [
    i64 1, label %.lr.ph.unr300
    i64 2, label %.lr.ph.unr299
  ]

.lr.ph.unr:                                       ; preds = %unr.cmp304
  %26 = add i64 %resume.val8, -1, !dbg !226
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !228
  %28 = load i8* %resume.val, align 1, !dbg !228, !tbaa !229
  %29 = getelementptr inbounds i8* %resume.val5, i64 1, !dbg !228
  store i8 %28, i8* %resume.val5, align 1, !dbg !228, !tbaa !229
  br label %.lr.ph.unr299

.lr.ph.unr299:                                    ; preds = %.lr.ph.unr, %unr.cmp304
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val8, %unr.cmp304 ]
  %30 = add i64 %.01.unr, -1, !dbg !226
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !228
  %32 = load i8* %src.03.unr, align 1, !dbg !228, !tbaa !229
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !228
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !228, !tbaa !229
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr299, %unr.cmp304
  %src.03.unr301 = phi i8* [ %31, %.lr.ph.unr299 ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr302 = phi i8* [ %33, %.lr.ph.unr299 ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr303 = phi i64 [ %30, %.lr.ph.unr299 ], [ %resume.val8, %unr.cmp304 ]
  %34 = add i64 %.01.unr303, -1, !dbg !226
  %35 = getelementptr inbounds i8* %src.03.unr301, i64 1, !dbg !228
  %36 = load i8* %src.03.unr301, align 1, !dbg !228, !tbaa !229
  %37 = getelementptr inbounds i8* %dest.02.unr302, i64 1, !dbg !228
  store i8 %36, i8* %dest.02.unr302, align 1, !dbg !228, !tbaa !229
  br label %.lr.ph.preheader.split

.lr.ph.preheader.split:                           ; preds = %.lr.ph.unr300, %.lr.ph.preheader
  %src.03.unr306 = phi i8* [ %resume.val, %.lr.ph.preheader ], [ %35, %.lr.ph.unr300 ]
  %dest.02.unr307 = phi i8* [ %resume.val5, %.lr.ph.preheader ], [ %37, %.lr.ph.unr300 ]
  %.01.unr308 = phi i64 [ %resume.val8, %.lr.ph.preheader ], [ %34, %.lr.ph.unr300 ]
  %38 = icmp ult i64 %resume.val8, 4
  br i1 %38, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader.split, %.lr.ph
  %src.03 = phi i8* [ %49, %.lr.ph ], [ %src.03.unr306, %.lr.ph.preheader.split ]
  %dest.02 = phi i8* [ %51, %.lr.ph ], [ %dest.02.unr307, %.lr.ph.preheader.split ]
  %.01 = phi i64 [ %48, %.lr.ph ], [ %.01.unr308, %.lr.ph.preheader.split ]
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !228
  %40 = load i8* %src.03, align 1, !dbg !228, !tbaa !229
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !228
  store i8 %40, i8* %dest.02, align 1, !dbg !228, !tbaa !229
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !228
  %43 = load i8* %39, align 1, !dbg !228, !tbaa !229
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !228
  store i8 %43, i8* %41, align 1, !dbg !228, !tbaa !229
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !228
  %46 = load i8* %42, align 1, !dbg !228, !tbaa !229
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !228
  store i8 %46, i8* %44, align 1, !dbg !228, !tbaa !229
  %48 = add i64 %.01, -4, !dbg !226
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !228
  %50 = load i8* %45, align 1, !dbg !228, !tbaa !229
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !228
  store i8 %50, i8* %47, align 1, !dbg !228, !tbaa !229
  %52 = icmp eq i64 %48, 0, !dbg !226
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !226, !llvm.loop !233

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block, %0
  ret i8* %destaddr, !dbg !234
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memmove(i8* %dst, i8* %src, i64 %count) #4 {
  %1 = icmp eq i8* %src, %dst, !dbg !235
  br i1 %1, label %.loopexit, label %2, !dbg !235

; <label>:2                                       ; preds = %0
  %3 = icmp ugt i8* %src, %dst, !dbg !237
  br i1 %3, label %.preheader, label %56, !dbg !237

.preheader:                                       ; preds = %2
  %4 = icmp eq i64 %count, 0, !dbg !239
  br i1 %4, label %.loopexit, label %overflow.checked227, !dbg !239

overflow.checked227:                              ; preds = %.preheader
  %n.vec224 = and i64 %count, -32
  %cmp.zero226 = icmp eq i64 %n.vec224, 0
  %5 = add i64 %count, -1
  br i1 %cmp.zero226, label %middle.block219, label %vector.memcheck234

vector.memcheck234:                               ; preds = %overflow.checked227
  %scevgep229 = getelementptr i8* %src, i64 %5
  %bound0230 = icmp uge i8* %scevgep229, %dst
  %scevgep228 = getelementptr i8* %dst, i64 %5
  %bound1231 = icmp uge i8* %scevgep228, %src
  %memcheck.conflict233 = and i1 %bound0230, %bound1231
  %ptr.ind.end = getelementptr i8* %src, i64 %n.vec224
  %ptr.ind.end239 = getelementptr i8* %dst, i64 %n.vec224
  %rev.ind.end242 = sub i64 %count, %n.vec224
  br i1 %memcheck.conflict233, label %middle.block219, label %vector.body218.preheader

vector.body218.preheader:                         ; preds = %vector.memcheck234
  %6 = add i64 %count, -32
  %7 = lshr i64 %6, 5
  %8 = add nuw nsw i64 %7, 1
  %xtraiter623 = and i64 %8, 1
  %lcmp.mod624 = icmp eq i64 %xtraiter623, 0
  br i1 %lcmp.mod624, label %vector.body218.preheader.split, label %vector.body218.unr

vector.body218.unr:                               ; preds = %vector.body218.preheader
  %9 = bitcast i8* %src to <16 x i8>*, !dbg !243
  %wide.load445.unr = load <16 x i8>* %9, align 1, !dbg !243, !tbaa !229
  %10 = getelementptr i8* %src, i64 16, !dbg !243
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !243
  %wide.load446.unr = load <16 x i8>* %11, align 1, !dbg !243, !tbaa !229
  %12 = bitcast i8* %dst to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load445.unr, <16 x i8>* %12, align 1, !dbg !243, !tbaa !229
  %13 = getelementptr i8* %dst, i64 16, !dbg !243
  %14 = bitcast i8* %13 to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load446.unr, <16 x i8>* %14, align 1, !dbg !243, !tbaa !229
  br label %vector.body218.preheader.split

vector.body218.preheader.split:                   ; preds = %vector.body218.unr, %vector.body218.preheader
  %index221.unr = phi i64 [ 0, %vector.body218.preheader ], [ 32, %vector.body218.unr ]
  %15 = icmp ult i64 %8, 2
  br i1 %15, label %middle.block219, label %vector.body218

vector.body218:                                   ; preds = %vector.body218.preheader.split, %vector.body218
  %index221 = phi i64 [ %index.next245.1, %vector.body218 ], [ %index221.unr, %vector.body218.preheader.split ]
  %next.gep247 = getelementptr i8* %src, i64 %index221
  %next.gep344 = getelementptr i8* %dst, i64 %index221
  %16 = bitcast i8* %next.gep247 to <16 x i8>*, !dbg !243
  %wide.load445 = load <16 x i8>* %16, align 1, !dbg !243, !tbaa !229
  %next.gep247.sum594 = or i64 %index221, 16, !dbg !243
  %17 = getelementptr i8* %src, i64 %next.gep247.sum594, !dbg !243
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !243
  %wide.load446 = load <16 x i8>* %18, align 1, !dbg !243, !tbaa !229
  %19 = bitcast i8* %next.gep344 to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load445, <16 x i8>* %19, align 1, !dbg !243, !tbaa !229
  %20 = getelementptr i8* %dst, i64 %next.gep247.sum594, !dbg !243
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load446, <16 x i8>* %21, align 1, !dbg !243, !tbaa !229
  %index.next245 = add i64 %index221, 32
  %next.gep247.1 = getelementptr i8* %src, i64 %index.next245
  %next.gep344.1 = getelementptr i8* %dst, i64 %index.next245
  %22 = bitcast i8* %next.gep247.1 to <16 x i8>*, !dbg !243
  %wide.load445.1 = load <16 x i8>* %22, align 1, !dbg !243, !tbaa !229
  %next.gep247.sum594.1 = or i64 %index.next245, 16, !dbg !243
  %23 = getelementptr i8* %src, i64 %next.gep247.sum594.1, !dbg !243
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !243
  %wide.load446.1 = load <16 x i8>* %24, align 1, !dbg !243, !tbaa !229
  %25 = bitcast i8* %next.gep344.1 to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load445.1, <16 x i8>* %25, align 1, !dbg !243, !tbaa !229
  %26 = getelementptr i8* %dst, i64 %next.gep247.sum594.1, !dbg !243
  %27 = bitcast i8* %26 to <16 x i8>*, !dbg !243
  store <16 x i8> %wide.load446.1, <16 x i8>* %27, align 1, !dbg !243, !tbaa !229
  %index.next245.1 = add i64 %index221, 64
  %28 = icmp eq i64 %index.next245.1, %n.vec224
  br i1 %28, label %middle.block219, label %vector.body218, !llvm.loop !245

middle.block219:                                  ; preds = %vector.body218, %vector.body218.preheader.split, %vector.memcheck234, %overflow.checked227
  %resume.val235 = phi i8* [ %src, %overflow.checked227 ], [ %src, %vector.memcheck234 ], [ %ptr.ind.end, %vector.body218.preheader.split ], [ %ptr.ind.end, %vector.body218 ]
  %resume.val237 = phi i8* [ %dst, %overflow.checked227 ], [ %dst, %vector.memcheck234 ], [ %ptr.ind.end239, %vector.body218.preheader.split ], [ %ptr.ind.end239, %vector.body218 ]
  %resume.val240 = phi i64 [ %count, %overflow.checked227 ], [ %count, %vector.memcheck234 ], [ %rev.ind.end242, %vector.body218.preheader.split ], [ %rev.ind.end242, %vector.body218 ]
  %new.indc.resume.val243 = phi i64 [ 0, %overflow.checked227 ], [ 0, %vector.memcheck234 ], [ %n.vec224, %vector.body218.preheader.split ], [ %n.vec224, %vector.body218 ]
  %cmp.n244 = icmp eq i64 %new.indc.resume.val243, %count
  br i1 %cmp.n244, label %.loopexit, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %middle.block219
  %xtraiter = and i64 %resume.val240, 3
  %lcmp.mod = icmp ne i64 %xtraiter, 0
  %lcmp.overflow = icmp eq i64 %resume.val240, 0
  %lcmp.or = or i1 %lcmp.overflow, %lcmp.mod
  br i1 %lcmp.or, label %unr.cmp618, label %.lr.ph.preheader.split

unr.cmp618:                                       ; preds = %.lr.ph.preheader
  switch i64 %xtraiter, label %.lr.ph.unr [
    i64 1, label %.lr.ph.unr614
    i64 2, label %.lr.ph.unr613
  ]

.lr.ph.unr:                                       ; preds = %unr.cmp618
  %29 = add i64 %resume.val240, -1, !dbg !239
  %30 = getelementptr inbounds i8* %resume.val235, i64 1, !dbg !243
  %31 = load i8* %resume.val235, align 1, !dbg !243, !tbaa !229
  %32 = getelementptr inbounds i8* %resume.val237, i64 1, !dbg !243
  store i8 %31, i8* %resume.val237, align 1, !dbg !243, !tbaa !229
  br label %.lr.ph.unr613

.lr.ph.unr613:                                    ; preds = %.lr.ph.unr, %unr.cmp618
  %b.05.unr = phi i8* [ %30, %.lr.ph.unr ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr = phi i8* [ %32, %.lr.ph.unr ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr = phi i64 [ %29, %.lr.ph.unr ], [ %resume.val240, %unr.cmp618 ]
  %33 = add i64 %.03.unr, -1, !dbg !239
  %34 = getelementptr inbounds i8* %b.05.unr, i64 1, !dbg !243
  %35 = load i8* %b.05.unr, align 1, !dbg !243, !tbaa !229
  %36 = getelementptr inbounds i8* %a.04.unr, i64 1, !dbg !243
  store i8 %35, i8* %a.04.unr, align 1, !dbg !243, !tbaa !229
  br label %.lr.ph.unr614

.lr.ph.unr614:                                    ; preds = %.lr.ph.unr613, %unr.cmp618
  %b.05.unr615 = phi i8* [ %34, %.lr.ph.unr613 ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr616 = phi i8* [ %36, %.lr.ph.unr613 ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr617 = phi i64 [ %33, %.lr.ph.unr613 ], [ %resume.val240, %unr.cmp618 ]
  %37 = add i64 %.03.unr617, -1, !dbg !239
  %38 = getelementptr inbounds i8* %b.05.unr615, i64 1, !dbg !243
  %39 = load i8* %b.05.unr615, align 1, !dbg !243, !tbaa !229
  %40 = getelementptr inbounds i8* %a.04.unr616, i64 1, !dbg !243
  store i8 %39, i8* %a.04.unr616, align 1, !dbg !243, !tbaa !229
  br label %.lr.ph.preheader.split

.lr.ph.preheader.split:                           ; preds = %.lr.ph.unr614, %.lr.ph.preheader
  %b.05.unr620 = phi i8* [ %resume.val235, %.lr.ph.preheader ], [ %38, %.lr.ph.unr614 ]
  %a.04.unr621 = phi i8* [ %resume.val237, %.lr.ph.preheader ], [ %40, %.lr.ph.unr614 ]
  %.03.unr622 = phi i64 [ %resume.val240, %.lr.ph.preheader ], [ %37, %.lr.ph.unr614 ]
  %41 = icmp ult i64 %resume.val240, 4
  br i1 %41, label %.loopexit, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader.split, %.lr.ph
  %b.05 = phi i8* [ %52, %.lr.ph ], [ %b.05.unr620, %.lr.ph.preheader.split ]
  %a.04 = phi i8* [ %54, %.lr.ph ], [ %a.04.unr621, %.lr.ph.preheader.split ]
  %.03 = phi i64 [ %51, %.lr.ph ], [ %.03.unr622, %.lr.ph.preheader.split ]
  %42 = getelementptr inbounds i8* %b.05, i64 1, !dbg !243
  %43 = load i8* %b.05, align 1, !dbg !243, !tbaa !229
  %44 = getelementptr inbounds i8* %a.04, i64 1, !dbg !243
  store i8 %43, i8* %a.04, align 1, !dbg !243, !tbaa !229
  %45 = getelementptr inbounds i8* %b.05, i64 2, !dbg !243
  %46 = load i8* %42, align 1, !dbg !243, !tbaa !229
  %47 = getelementptr inbounds i8* %a.04, i64 2, !dbg !243
  store i8 %46, i8* %44, align 1, !dbg !243, !tbaa !229
  %48 = getelementptr inbounds i8* %b.05, i64 3, !dbg !243
  %49 = load i8* %45, align 1, !dbg !243, !tbaa !229
  %50 = getelementptr inbounds i8* %a.04, i64 3, !dbg !243
  store i8 %49, i8* %47, align 1, !dbg !243, !tbaa !229
  %51 = add i64 %.03, -4, !dbg !239
  %52 = getelementptr inbounds i8* %b.05, i64 4, !dbg !243
  %53 = load i8* %48, align 1, !dbg !243, !tbaa !229
  %54 = getelementptr inbounds i8* %a.04, i64 4, !dbg !243
  store i8 %53, i8* %50, align 1, !dbg !243, !tbaa !229
  %55 = icmp eq i64 %51, 0, !dbg !239
  br i1 %55, label %.loopexit, label %.lr.ph, !dbg !239, !llvm.loop !246

; <label>:56                                      ; preds = %2
  %57 = add i64 %count, -1, !dbg !247
  %58 = icmp eq i64 %count, 0, !dbg !249
  br i1 %58, label %.loopexit, label %.lr.ph9, !dbg !249

.lr.ph9:                                          ; preds = %56
  %59 = getelementptr inbounds i8* %src, i64 %57, !dbg !252
  %60 = getelementptr inbounds i8* %dst, i64 %57, !dbg !247
  %n.vec = and i64 %count, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %.lr.ph9
  %bound0 = icmp ule i8* %60, %src
  %bound1 = icmp ule i8* %59, %dst
  %memcheck.conflict = and i1 %bound0, %bound1
  %.sum = sub i64 %57, %n.vec
  %rev.ptr.ind.end = getelementptr i8* %src, i64 %.sum
  %rev.ptr.ind.end15 = getelementptr i8* %dst, i64 %.sum
  %rev.ind.end18 = sub i64 %count, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.memcheck, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %vector.memcheck ]
  %.sum448 = sub i64 %57, %index
  %next.gep.sum = add i64 %.sum448, -15, !dbg !253
  %61 = getelementptr i8* %src, i64 %next.gep.sum, !dbg !253
  %62 = bitcast i8* %61 to <16 x i8>*, !dbg !253
  %wide.load = load <16 x i8>* %62, align 1, !dbg !253, !tbaa !229
  %.sum513 = add i64 %.sum448, -31, !dbg !253
  %63 = getelementptr i8* %src, i64 %.sum513, !dbg !253
  %64 = bitcast i8* %63 to <16 x i8>*, !dbg !253
  %wide.load211 = load <16 x i8>* %64, align 1, !dbg !253, !tbaa !229
  %65 = getelementptr i8* %dst, i64 %next.gep.sum, !dbg !253
  %66 = bitcast i8* %65 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load, <16 x i8>* %66, align 1, !dbg !253, !tbaa !229
  %67 = getelementptr i8* %dst, i64 %.sum513, !dbg !253
  %68 = bitcast i8* %67 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load211, <16 x i8>* %68, align 1, !dbg !253, !tbaa !229
  %index.next = add i64 %index, 32
  %69 = icmp eq i64 %index.next, %n.vec
  br i1 %69, label %middle.block, label %vector.body, !llvm.loop !255

middle.block:                                     ; preds = %vector.body, %vector.memcheck, %.lr.ph9
  %70 = phi i64 [ %57, %.lr.ph9 ], [ %57, %vector.memcheck ], [ %.sum, %vector.body ]
  %resume.val = phi i8* [ %59, %.lr.ph9 ], [ %59, %vector.memcheck ], [ %rev.ptr.ind.end, %vector.body ]
  %resume.val12 = phi i8* [ %60, %.lr.ph9 ], [ %60, %vector.memcheck ], [ %rev.ptr.ind.end15, %vector.body ]
  %resume.val16 = phi i64 [ %count, %.lr.ph9 ], [ %count, %vector.memcheck ], [ %rev.ind.end18, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %.lr.ph9 ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %count
  br i1 %cmp.n, label %.loopexit, label %scalar.ph.preheader

scalar.ph.preheader:                              ; preds = %middle.block
  %xtraiter627 = and i64 %resume.val16, 3
  %lcmp.mod628 = icmp ne i64 %xtraiter627, 0
  %lcmp.overflow629 = icmp eq i64 %resume.val16, 0
  %lcmp.or630 = or i1 %lcmp.overflow629, %lcmp.mod628
  br i1 %lcmp.or630, label %unr.cmp638, label %scalar.ph.preheader.split

unr.cmp638:                                       ; preds = %scalar.ph.preheader
  switch i64 %xtraiter627, label %scalar.ph.unr [
    i64 1, label %scalar.ph.unr634
    i64 2, label %scalar.ph.unr631
  ]

scalar.ph.unr:                                    ; preds = %unr.cmp638
  %71 = add i64 %resume.val16, -1, !dbg !249
  %.sum1 = add i64 %70, -1, !dbg !253
  %72 = getelementptr inbounds i8* %src, i64 %.sum1, !dbg !253
  %73 = load i8* %resume.val, align 1, !dbg !253, !tbaa !229
  %74 = getelementptr inbounds i8* %dst, i64 %.sum1, !dbg !253
  store i8 %73, i8* %resume.val12, align 1, !dbg !253, !tbaa !229
  br label %scalar.ph.unr631

scalar.ph.unr631:                                 ; preds = %scalar.ph.unr, %unr.cmp638
  %b.18.unr = phi i8* [ %72, %scalar.ph.unr ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr = phi i8* [ %74, %scalar.ph.unr ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr = phi i64 [ %71, %scalar.ph.unr ], [ %resume.val16, %unr.cmp638 ]
  %75 = add i64 %.16.unr, -1, !dbg !249
  %76 = getelementptr inbounds i8* %b.18.unr, i64 -1, !dbg !253
  %77 = load i8* %b.18.unr, align 1, !dbg !253, !tbaa !229
  %78 = getelementptr inbounds i8* %a.17.unr, i64 -1, !dbg !253
  store i8 %77, i8* %a.17.unr, align 1, !dbg !253, !tbaa !229
  br label %scalar.ph.unr634

scalar.ph.unr634:                                 ; preds = %scalar.ph.unr631, %unr.cmp638
  %b.18.unr635 = phi i8* [ %76, %scalar.ph.unr631 ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr636 = phi i8* [ %78, %scalar.ph.unr631 ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr637 = phi i64 [ %75, %scalar.ph.unr631 ], [ %resume.val16, %unr.cmp638 ]
  %79 = add i64 %.16.unr637, -1, !dbg !249
  %80 = getelementptr inbounds i8* %b.18.unr635, i64 -1, !dbg !253
  %81 = load i8* %b.18.unr635, align 1, !dbg !253, !tbaa !229
  %82 = getelementptr inbounds i8* %a.17.unr636, i64 -1, !dbg !253
  store i8 %81, i8* %a.17.unr636, align 1, !dbg !253, !tbaa !229
  br label %scalar.ph.preheader.split

scalar.ph.preheader.split:                        ; preds = %scalar.ph.unr634, %scalar.ph.preheader
  %b.18.unr640 = phi i8* [ %resume.val, %scalar.ph.preheader ], [ %80, %scalar.ph.unr634 ]
  %a.17.unr641 = phi i8* [ %resume.val12, %scalar.ph.preheader ], [ %82, %scalar.ph.unr634 ]
  %.16.unr642 = phi i64 [ %resume.val16, %scalar.ph.preheader ], [ %79, %scalar.ph.unr634 ]
  %83 = icmp ult i64 %resume.val16, 4
  br i1 %83, label %.loopexit, label %scalar.ph

scalar.ph:                                        ; preds = %scalar.ph.preheader.split, %scalar.ph
  %b.18 = phi i8* [ %94, %scalar.ph ], [ %b.18.unr640, %scalar.ph.preheader.split ]
  %a.17 = phi i8* [ %96, %scalar.ph ], [ %a.17.unr641, %scalar.ph.preheader.split ]
  %.16 = phi i64 [ %93, %scalar.ph ], [ %.16.unr642, %scalar.ph.preheader.split ]
  %84 = getelementptr inbounds i8* %b.18, i64 -1, !dbg !253
  %85 = load i8* %b.18, align 1, !dbg !253, !tbaa !229
  %86 = getelementptr inbounds i8* %a.17, i64 -1, !dbg !253
  store i8 %85, i8* %a.17, align 1, !dbg !253, !tbaa !229
  %87 = getelementptr inbounds i8* %b.18, i64 -2, !dbg !253
  %88 = load i8* %84, align 1, !dbg !253, !tbaa !229
  %89 = getelementptr inbounds i8* %a.17, i64 -2, !dbg !253
  store i8 %88, i8* %86, align 1, !dbg !253, !tbaa !229
  %90 = getelementptr inbounds i8* %b.18, i64 -3, !dbg !253
  %91 = load i8* %87, align 1, !dbg !253, !tbaa !229
  %92 = getelementptr inbounds i8* %a.17, i64 -3, !dbg !253
  store i8 %91, i8* %89, align 1, !dbg !253, !tbaa !229
  %93 = add i64 %.16, -4, !dbg !249
  %94 = getelementptr inbounds i8* %b.18, i64 -4, !dbg !253
  %95 = load i8* %90, align 1, !dbg !253, !tbaa !229
  %96 = getelementptr inbounds i8* %a.17, i64 -4, !dbg !253
  store i8 %95, i8* %92, align 1, !dbg !253, !tbaa !229
  %97 = icmp eq i64 %93, 0, !dbg !249
  br i1 %97, label %.loopexit, label %scalar.ph, !dbg !249, !llvm.loop !256

.loopexit:                                        ; preds = %scalar.ph, %.lr.ph, %scalar.ph.preheader.split, %middle.block, %56, %.lr.ph.preheader.split, %middle.block219, %.preheader, %0
  ret i8* %dst, !dbg !257
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !258
  br i1 %1, label %53, label %overflow.checked, !dbg !258

overflow.checked:                                 ; preds = %0
  %n.vec = and i64 %len, -32
  %cmp.zero = icmp eq i64 %n.vec, 0
  %2 = add i64 %len, -1
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %overflow.checked
  %scevgep5 = getelementptr i8* %srcaddr, i64 %2
  %bound0 = icmp uge i8* %scevgep5, %destaddr
  %scevgep4 = getelementptr i8* %destaddr, i64 %2
  %bound1 = icmp uge i8* %scevgep4, %srcaddr
  %memcheck.conflict = and i1 %bound0, %bound1
  %ptr.ind.end = getelementptr i8* %srcaddr, i64 %n.vec
  %ptr.ind.end8 = getelementptr i8* %destaddr, i64 %n.vec
  %rev.ind.end = sub i64 %len, %n.vec
  br i1 %memcheck.conflict, label %middle.block, label %vector.body.preheader

vector.body.preheader:                            ; preds = %vector.memcheck
  %3 = add i64 %len, -32
  %4 = lshr i64 %3, 5
  %5 = add nuw nsw i64 %4, 1
  %xtraiter310 = and i64 %5, 1
  %lcmp.mod311 = icmp eq i64 %xtraiter310, 0
  br i1 %lcmp.mod311, label %vector.body.preheader.split, label %vector.body.unr

vector.body.unr:                                  ; preds = %vector.body.preheader
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !260
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !260, !tbaa !229
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !260
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !260
  %wide.load203.unr = load <16 x i8>* %8, align 1, !dbg !260, !tbaa !229
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !260, !tbaa !229
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !260
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load203.unr, <16 x i8>* %11, align 1, !dbg !260, !tbaa !229
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep106 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !260
  %wide.load = load <16 x i8>* %13, align 1, !dbg !260, !tbaa !229
  %next.gep.sum282 = or i64 %index, 16, !dbg !260
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum282, !dbg !260
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !260
  %wide.load203 = load <16 x i8>* %15, align 1, !dbg !260, !tbaa !229
  %16 = bitcast i8* %next.gep106 to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !260, !tbaa !229
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum282, !dbg !260
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load203, <16 x i8>* %18, align 1, !dbg !260, !tbaa !229
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep106.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !260
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !260, !tbaa !229
  %next.gep.sum282.1 = or i64 %index.next, 16, !dbg !260
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum282.1, !dbg !260
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !260
  %wide.load203.1 = load <16 x i8>* %21, align 1, !dbg !260, !tbaa !229
  %22 = bitcast i8* %next.gep106.1 to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !260, !tbaa !229
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum282.1, !dbg !260
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !260
  store <16 x i8> %wide.load203.1, <16 x i8>* %24, align 1, !dbg !260, !tbaa !229
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !261

middle.block:                                     ; preds = %vector.body, %vector.body.preheader.split, %vector.memcheck, %overflow.checked
  %resume.val = phi i8* [ %srcaddr, %overflow.checked ], [ %srcaddr, %vector.memcheck ], [ %ptr.ind.end, %vector.body.preheader.split ], [ %ptr.ind.end, %vector.body ]
  %resume.val6 = phi i8* [ %destaddr, %overflow.checked ], [ %destaddr, %vector.memcheck ], [ %ptr.ind.end8, %vector.body.preheader.split ], [ %ptr.ind.end8, %vector.body ]
  %resume.val9 = phi i64 [ %len, %overflow.checked ], [ %len, %vector.memcheck ], [ %rev.ind.end, %vector.body.preheader.split ], [ %rev.ind.end, %vector.body ]
  %new.indc.resume.val = phi i64 [ 0, %overflow.checked ], [ 0, %vector.memcheck ], [ %n.vec, %vector.body.preheader.split ], [ %n.vec, %vector.body ]
  %cmp.n = icmp eq i64 %new.indc.resume.val, %len
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %middle.block
  %xtraiter = and i64 %resume.val9, 3
  %lcmp.mod = icmp ne i64 %xtraiter, 0
  %lcmp.overflow = icmp eq i64 %resume.val9, 0
  %lcmp.or = or i1 %lcmp.overflow, %lcmp.mod
  br i1 %lcmp.or, label %unr.cmp305, label %.lr.ph.preheader.split

unr.cmp305:                                       ; preds = %.lr.ph.preheader
  switch i64 %xtraiter, label %.lr.ph.unr [
    i64 1, label %.lr.ph.unr301
    i64 2, label %.lr.ph.unr300
  ]

.lr.ph.unr:                                       ; preds = %unr.cmp305
  %26 = add i64 %resume.val9, -1, !dbg !258
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !260
  %28 = load i8* %resume.val, align 1, !dbg !260, !tbaa !229
  %29 = getelementptr inbounds i8* %resume.val6, i64 1, !dbg !260
  store i8 %28, i8* %resume.val6, align 1, !dbg !260, !tbaa !229
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr, %unr.cmp305
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val9, %unr.cmp305 ]
  %30 = add i64 %.01.unr, -1, !dbg !258
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !260
  %32 = load i8* %src.03.unr, align 1, !dbg !260, !tbaa !229
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !260
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !260, !tbaa !229
  br label %.lr.ph.unr301

.lr.ph.unr301:                                    ; preds = %.lr.ph.unr300, %unr.cmp305
  %src.03.unr302 = phi i8* [ %31, %.lr.ph.unr300 ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr303 = phi i8* [ %33, %.lr.ph.unr300 ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr304 = phi i64 [ %30, %.lr.ph.unr300 ], [ %resume.val9, %unr.cmp305 ]
  %34 = add i64 %.01.unr304, -1, !dbg !258
  %35 = getelementptr inbounds i8* %src.03.unr302, i64 1, !dbg !260
  %36 = load i8* %src.03.unr302, align 1, !dbg !260, !tbaa !229
  %37 = getelementptr inbounds i8* %dest.02.unr303, i64 1, !dbg !260
  store i8 %36, i8* %dest.02.unr303, align 1, !dbg !260, !tbaa !229
  br label %.lr.ph.preheader.split

.lr.ph.preheader.split:                           ; preds = %.lr.ph.unr301, %.lr.ph.preheader
  %src.03.unr307 = phi i8* [ %resume.val, %.lr.ph.preheader ], [ %35, %.lr.ph.unr301 ]
  %dest.02.unr308 = phi i8* [ %resume.val6, %.lr.ph.preheader ], [ %37, %.lr.ph.unr301 ]
  %.01.unr309 = phi i64 [ %resume.val9, %.lr.ph.preheader ], [ %34, %.lr.ph.unr301 ]
  %38 = icmp ult i64 %resume.val9, 4
  br i1 %38, label %._crit_edge, label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader.split, %.lr.ph
  %src.03 = phi i8* [ %49, %.lr.ph ], [ %src.03.unr307, %.lr.ph.preheader.split ]
  %dest.02 = phi i8* [ %51, %.lr.ph ], [ %dest.02.unr308, %.lr.ph.preheader.split ]
  %.01 = phi i64 [ %48, %.lr.ph ], [ %.01.unr309, %.lr.ph.preheader.split ]
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !260
  %40 = load i8* %src.03, align 1, !dbg !260, !tbaa !229
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !260
  store i8 %40, i8* %dest.02, align 1, !dbg !260, !tbaa !229
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !260
  %43 = load i8* %39, align 1, !dbg !260, !tbaa !229
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !260
  store i8 %43, i8* %41, align 1, !dbg !260, !tbaa !229
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !260
  %46 = load i8* %42, align 1, !dbg !260, !tbaa !229
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !260
  store i8 %46, i8* %44, align 1, !dbg !260, !tbaa !229
  %48 = add i64 %.01, -4, !dbg !258
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !260
  %50 = load i8* %45, align 1, !dbg !260, !tbaa !229
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !260
  store i8 %50, i8* %47, align 1, !dbg !260, !tbaa !229
  %52 = icmp eq i64 %48, 0, !dbg !258
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !258, !llvm.loop !262

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %53, !dbg !258

; <label>:53                                      ; preds = %._crit_edge, %0
  %dest.0.lcssa = phi i8* [ %scevgep, %._crit_edge ], [ %destaddr, %0 ]
  ret i8* %dest.0.lcssa, !dbg !263
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memset(i8* %dst, i32 %s, i64 %count) #4 {
  %1 = icmp eq i64 %count, 0, !dbg !264
  br i1 %1, label %._crit_edge, label %.lr.ph, !dbg !264

.lr.ph:                                           ; preds = %0
  %2 = trunc i32 %s to i8, !dbg !266
  %xtraiter = and i64 %count, 3
  switch i64 %xtraiter, label %3 [
    i64 0, label %.lr.ph.split
    i64 1, label %9
    i64 2, label %6
  ]

; <label>:3                                       ; preds = %.lr.ph
  %4 = add i64 %count, -1, !dbg !264
  %5 = getelementptr inbounds i8* %dst, i64 1, !dbg !266
  store volatile i8 %2, i8* %dst, align 1, !dbg !266, !tbaa !229
  br label %6

; <label>:6                                       ; preds = %3, %.lr.ph
  %a.02.unr = phi i8* [ %5, %3 ], [ %dst, %.lr.ph ]
  %.01.unr = phi i64 [ %4, %3 ], [ %count, %.lr.ph ]
  %7 = add i64 %.01.unr, -1, !dbg !264
  %8 = getelementptr inbounds i8* %a.02.unr, i64 1, !dbg !266
  store volatile i8 %2, i8* %a.02.unr, align 1, !dbg !266, !tbaa !229
  br label %9

; <label>:9                                       ; preds = %6, %.lr.ph
  %a.02.unr3 = phi i8* [ %8, %6 ], [ %dst, %.lr.ph ]
  %.01.unr4 = phi i64 [ %7, %6 ], [ %count, %.lr.ph ]
  %10 = add i64 %.01.unr4, -1, !dbg !264
  %11 = getelementptr inbounds i8* %a.02.unr3, i64 1, !dbg !266
  store volatile i8 %2, i8* %a.02.unr3, align 1, !dbg !266, !tbaa !229
  br label %.lr.ph.split

.lr.ph.split:                                     ; preds = %9, %.lr.ph
  %a.02.unr7 = phi i8* [ %dst, %.lr.ph ], [ %11, %9 ]
  %.01.unr8 = phi i64 [ %count, %.lr.ph ], [ %10, %9 ]
  %12 = icmp ult i64 %count, 4
  br i1 %12, label %._crit_edge, label %.lr.ph.split.split

.lr.ph.split.split:                               ; preds = %.lr.ph.split, %.lr.ph.split.split
  %a.02 = phi i8* [ %17, %.lr.ph.split.split ], [ %a.02.unr7, %.lr.ph.split ]
  %.01 = phi i64 [ %16, %.lr.ph.split.split ], [ %.01.unr8, %.lr.ph.split ]
  %13 = getelementptr inbounds i8* %a.02, i64 1, !dbg !266
  store volatile i8 %2, i8* %a.02, align 1, !dbg !266, !tbaa !229
  %14 = getelementptr inbounds i8* %a.02, i64 2, !dbg !266
  store volatile i8 %2, i8* %13, align 1, !dbg !266, !tbaa !229
  %15 = getelementptr inbounds i8* %a.02, i64 3, !dbg !266
  store volatile i8 %2, i8* %14, align 1, !dbg !266, !tbaa !229
  %16 = add i64 %.01, -4, !dbg !264
  %17 = getelementptr inbounds i8* %a.02, i64 4, !dbg !266
  store volatile i8 %2, i8* %15, align 1, !dbg !266, !tbaa !229
  %18 = icmp eq i64 %16, 0, !dbg !264
  br i1 %18, label %._crit_edge, label %.lr.ph.split.split, !dbg !264

._crit_edge:                                      ; preds = %.lr.ph.split.split, %.lr.ph.split, %0
  ret i8* %dst, !dbg !267
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="4" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nobuiltin noreturn nounwind }
attributes #8 = { nobuiltin nounwind }

!llvm.dbg.cu = !{!0, !15, !26, !39, !51, !64, !84, !96, !108}
!llvm.module.flags = !{!123, !124}
!llvm.ident = !{!125, !125, !125, !125, !125, !125, !125, !125, !125}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metad
!1 = metadata !{metadata !"hash.c", metadata !"/playpen/ziqiao/2project/klee/analyzer/hash"}
!2 = metadata !{}
!3 = metadata !{metadata !4, metadata !11}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"hash", metadata !"hash", metadata !"", i32 6, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i8*, i8*, i32, i32)* @hash, null, null, metadata !2, i32 6} ; 
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8, metadata !8, metadata !8, metadata !10, metadata !10}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 31, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 31} ; [ DW_TAG_s
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{metadata !10, metadata !10, metadata !14}
!14 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!15 = metadata !{i32 786449, metadata !16, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !17, metadata !2, metadata !2, meta
!16 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 786478, metadata !19, metadata !20, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"", i32 12, metadata !21, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* @klee_div_zero_check, null
!19 = metadata !{metadata !"klee_div_zero_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!20 = metadata !{i32 786473, metadata !19}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c]
!21 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !22, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!22 = metadata !{null, metadata !23}
!23 = metadata !{i32 786468, null, null, metadata !"long long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!24 = metadata !{metadata !25}
!25 = metadata !{i32 786689, metadata !18, metadata !"z", metadata !20, i32 16777228, metadata !23, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [z] [line 12]
!26 = metadata !{i32 786449, metadata !27, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !28, metadata !2, metadata !2, meta
!27 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_int.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!28 = metadata !{metadata !29}
!29 = metadata !{i32 786478, metadata !30, metadata !31, metadata !"klee_int", metadata !"klee_int", metadata !"", i32 13, metadata !32, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int, null, null, metadata !36, i32 13} ; [ 
!30 = metadata !{metadata !"klee_int.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!31 = metadata !{i32 786473, metadata !30}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_int.c]
!32 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !33, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!33 = metadata !{metadata !10, metadata !34}
!34 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !35} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!35 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!36 = metadata !{metadata !37, metadata !38}
!37 = metadata !{i32 786689, metadata !29, metadata !"name", metadata !31, i32 16777229, metadata !34, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!38 = metadata !{i32 786688, metadata !29, metadata !"x", metadata !31, i32 14, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!39 = metadata !{i32 786449, metadata !40, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !41, metadata !2, metadata !2, meta
!40 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!41 = metadata !{metadata !42}
!42 = metadata !{i32 786478, metadata !43, metadata !44, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"", i32 20, metadata !45, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64, i64)* @klee_overshift_che
!43 = metadata !{metadata !"klee_overshift_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!44 = metadata !{i32 786473, metadata !43}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!45 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !46, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!46 = metadata !{null, metadata !47, metadata !47}
!47 = metadata !{i32 786468, null, null, metadata !"long long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!48 = metadata !{metadata !49, metadata !50}
!49 = metadata !{i32 786689, metadata !42, metadata !"bitWidth", metadata !44, i32 16777236, metadata !47, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bitWidth] [line 20]
!50 = metadata !{i32 786689, metadata !42, metadata !"shift", metadata !44, i32 33554452, metadata !47, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [shift] [line 20]
!51 = metadata !{i32 786449, metadata !52, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !53, metadata !2, metadata !2, meta
!52 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!53 = metadata !{metadata !54}
!54 = metadata !{i32 786478, metadata !55, metadata !56, metadata !"klee_range", metadata !"klee_range", metadata !"", i32 13, metadata !57, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range, null, null, metadata !
!55 = metadata !{metadata !"klee_range.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!56 = metadata !{i32 786473, metadata !55}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!57 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !58, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!58 = metadata !{metadata !10, metadata !10, metadata !10, metadata !34}
!59 = metadata !{metadata !60, metadata !61, metadata !62, metadata !63}
!60 = metadata !{i32 786689, metadata !54, metadata !"start", metadata !56, i32 16777229, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [start] [line 13]
!61 = metadata !{i32 786689, metadata !54, metadata !"end", metadata !56, i32 33554445, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [end] [line 13]
!62 = metadata !{i32 786689, metadata !54, metadata !"name", metadata !56, i32 50331661, metadata !34, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!63 = metadata !{i32 786688, metadata !54, metadata !"x", metadata !56, i32 14, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!64 = metadata !{i32 786449, metadata !65, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !66, metadata !2, metadata !2, meta
!65 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!66 = metadata !{metadata !67}
!67 = metadata !{i32 786478, metadata !68, metadata !69, metadata !"memcpy", metadata !"memcpy", metadata !"", i32 12, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memcpy, null, null, metadata !78, i32 12} 
!68 = metadata !{metadata !"memcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!69 = metadata !{i32 786473, metadata !68}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c]
!70 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !71, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!71 = metadata !{metadata !72, metadata !72, metadata !73, metadata !75}
!72 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!73 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !74} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!74 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!75 = metadata !{i32 786454, metadata !76, null, metadata !"size_t", i32 58, i64 0, i64 0, i64 0, i32 0, metadata !77} ; [ DW_TAG_typedef ] [size_t] [line 58, size 0, align 0, offset 0] [from long unsigned int]
!76 = metadata !{metadata !"/usr/lib/llvm-3.5/bin/../lib/clang/3.5.0/include/stddef.h", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!77 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!78 = metadata !{metadata !79, metadata !80, metadata !81, metadata !82, metadata !83}
!79 = metadata !{i32 786689, metadata !67, metadata !"destaddr", metadata !69, i32 16777228, metadata !72, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 12]
!80 = metadata !{i32 786689, metadata !67, metadata !"srcaddr", metadata !69, i32 33554444, metadata !73, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 12]
!81 = metadata !{i32 786689, metadata !67, metadata !"len", metadata !69, i32 50331660, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 12]
!82 = metadata !{i32 786688, metadata !67, metadata !"dest", metadata !69, i32 13, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 13]
!83 = metadata !{i32 786688, metadata !67, metadata !"src", metadata !69, i32 14, metadata !34, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 14]
!84 = metadata !{i32 786449, metadata !85, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !86, metadata !2, metadata !2, meta
!85 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!86 = metadata !{metadata !87}
!87 = metadata !{i32 786478, metadata !88, metadata !89, metadata !"memmove", metadata !"memmove", metadata !"", i32 12, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memmove, null, null, metadata !90, i32 1
!88 = metadata !{metadata !"memmove.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!89 = metadata !{i32 786473, metadata !88}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!90 = metadata !{metadata !91, metadata !92, metadata !93, metadata !94, metadata !95}
!91 = metadata !{i32 786689, metadata !87, metadata !"dst", metadata !89, i32 16777228, metadata !72, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 12]
!92 = metadata !{i32 786689, metadata !87, metadata !"src", metadata !89, i32 33554444, metadata !73, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [src] [line 12]
!93 = metadata !{i32 786689, metadata !87, metadata !"count", metadata !89, i32 50331660, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 12]
!94 = metadata !{i32 786688, metadata !87, metadata !"a", metadata !89, i32 13, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 13]
!95 = metadata !{i32 786688, metadata !87, metadata !"b", metadata !89, i32 14, metadata !34, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [b] [line 14]
!96 = metadata !{i32 786449, metadata !97, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !98, metadata !2, metadata !2, meta
!97 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!98 = metadata !{metadata !99}
!99 = metadata !{i32 786478, metadata !100, metadata !101, metadata !"mempcpy", metadata !"mempcpy", metadata !"", i32 11, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy, null, null, metadata !102, i3
!100 = metadata !{metadata !"mempcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!101 = metadata !{i32 786473, metadata !100}      ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c]
!102 = metadata !{metadata !103, metadata !104, metadata !105, metadata !106, metadata !107}
!103 = metadata !{i32 786689, metadata !99, metadata !"destaddr", metadata !101, i32 16777227, metadata !72, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 11]
!104 = metadata !{i32 786689, metadata !99, metadata !"srcaddr", metadata !101, i32 33554443, metadata !73, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 11]
!105 = metadata !{i32 786689, metadata !99, metadata !"len", metadata !101, i32 50331659, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 11]
!106 = metadata !{i32 786688, metadata !99, metadata !"dest", metadata !101, i32 12, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 12]
!107 = metadata !{i32 786688, metadata !99, metadata !"src", metadata !101, i32 13, metadata !34, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 13]
!108 = metadata !{i32 786449, metadata !109, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !110, metadata !2, metadata !2, m
!109 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!110 = metadata !{metadata !111}
!111 = metadata !{i32 786478, metadata !112, metadata !113, metadata !"memset", metadata !"memset", metadata !"", i32 11, metadata !114, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i64)* @memset, null, null, metadata !116, i32
!112 = metadata !{metadata !"memset.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!113 = metadata !{i32 786473, metadata !112}      ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c]
!114 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !115, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!115 = metadata !{metadata !72, metadata !72, metadata !10, metadata !75}
!116 = metadata !{metadata !117, metadata !118, metadata !119, metadata !120}
!117 = metadata !{i32 786689, metadata !111, metadata !"dst", metadata !113, i32 16777227, metadata !72, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 11]
!118 = metadata !{i32 786689, metadata !111, metadata !"s", metadata !113, i32 33554443, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s] [line 11]
!119 = metadata !{i32 786689, metadata !111, metadata !"count", metadata !113, i32 50331659, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 11]
!120 = metadata !{i32 786688, metadata !111, metadata !"a", metadata !113, i32 12, metadata !121, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 12]
!121 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !122} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!122 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from char]
!123 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!124 = metadata !{i32 2, metadata !"Debug Info Version", i32 1}
!125 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
!126 = metadata !{i32 7, i32 6, metadata !127, null}
!127 = metadata !{i32 786443, metadata !1, metadata !4, i32 7, i32 6, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!128 = metadata !{i32 7, i32 6, metadata !129, null}
!129 = metadata !{i32 786443, metadata !1, metadata !127, i32 7, i32 6, i32 2, i32 14} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!130 = metadata !{i32 7, i32 30, metadata !131, null}
!131 = metadata !{i32 786443, metadata !1, metadata !132, i32 7, i32 30, i32 3, i32 15} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!132 = metadata !{i32 786443, metadata !1, metadata !127, i32 7, i32 30, i32 1, i32 13} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!133 = metadata !{i32 11, i32 7, metadata !134, null}
!134 = metadata !{i32 786443, metadata !1, metadata !4, i32 11, i32 2, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!135 = metadata !{i32 11, i32 7, metadata !136, null}
!136 = metadata !{i32 786443, metadata !1, metadata !137, i32 11, i32 7, i32 2, i32 23} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!137 = metadata !{i32 786443, metadata !1, metadata !134, i32 11, i32 7, i32 1, i32 16} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!138 = metadata !{i32 12, i32 3, metadata !139, null}
!139 = metadata !{i32 786443, metadata !1, metadata !134, i32 11, i32 19, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!140 = metadata !{i32 13, i32 7, metadata !141, null}
!141 = metadata !{i32 786443, metadata !1, metadata !139, i32 13, i32 3, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!142 = metadata !{i32 13, i32 7, metadata !143, null}
!143 = metadata !{i32 786443, metadata !1, metadata !144, i32 13, i32 7, i32 2, i32 22} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!144 = metadata !{i32 786443, metadata !1, metadata !141, i32 13, i32 7, i32 1, i32 17} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!145 = metadata !{i32 14, i32 4, metadata !146, null}
!146 = metadata !{i32 786443, metadata !1, metadata !141, i32 13, i32 19, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!147 = metadata !{i32 15, i32 8, metadata !148, null}
!148 = metadata !{i32 786443, metadata !1, metadata !146, i32 15, i32 4, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!149 = metadata !{i32 15, i32 8, metadata !150, null}
!150 = metadata !{i32 786443, metadata !1, metadata !151, i32 15, i32 8, i32 2, i32 21} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!151 = metadata !{i32 786443, metadata !1, metadata !148, i32 15, i32 8, i32 1, i32 18} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!152 = metadata !{i32 16, i32 5, metadata !153, null}
!153 = metadata !{i32 786443, metadata !1, metadata !148, i32 15, i32 20, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!154 = metadata !{i32 17, i32 5, metadata !153, null}
!155 = metadata !{i32 18, i32 5, metadata !153, null}
!156 = metadata !{i32 19, i32 9, metadata !157, null}
!157 = metadata !{i32 786443, metadata !1, metadata !153, i32 19, i32 5, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!158 = metadata !{i32 19, i32 9, metadata !159, null}
!159 = metadata !{i32 786443, metadata !1, metadata !160, i32 19, i32 9, i32 2, i32 20} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!160 = metadata !{i32 786443, metadata !1, metadata !157, i32 19, i32 9, i32 1, i32 19} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!161 = metadata !{i32 20, i32 6, metadata !162, null}
!162 = metadata !{i32 786443, metadata !1, metadata !157, i32 19, i32 21, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!163 = metadata !{i32 21, i32 6, metadata !162, null}
!164 = metadata !{i32 19, i32 17, metadata !157, null}
!165 = metadata !{i32 15, i32 16, metadata !148, null}
!166 = metadata !{i32 24, i32 4, metadata !146, null}
!167 = metadata !{i32 13, i32 15, metadata !141, null}
!168 = metadata !{i32 11, i32 15, metadata !134, null}
!169 = metadata !{i32 29, i32 1, metadata !4, null}
!170 = metadata !{i32 32, i32 2, metadata !11, null}
!171 = metadata !{i32 35, i32 2, metadata !11, null}
!172 = metadata !{i32 37, i32 7, metadata !173, null}
!173 = metadata !{i32 786443, metadata !1, metadata !11, i32 37, i32 2, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!174 = metadata !{i32 37, i32 7, metadata !175, null}
!175 = metadata !{i32 786443, metadata !1, metadata !176, i32 37, i32 7, i32 2, i32 25} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!176 = metadata !{i32 786443, metadata !1, metadata !173, i32 37, i32 7, i32 1, i32 24} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!177 = metadata !{i32 38, i32 3, metadata !178, null}
!178 = metadata !{i32 786443, metadata !1, metadata !173, i32 37, i32 20, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!179 = metadata !{i32 37, i32 16, metadata !173, null}
!180 = metadata !{i32 40, i32 2, metadata !11, null}
!181 = metadata !{i32 43, i32 2, metadata !11, null}
!182 = metadata !{i32 44, i32 2, metadata !11, null}
!183 = metadata !{i32 45, i32 5, metadata !184, null}
!184 = metadata !{i32 786443, metadata !1, metadata !11, i32 45, i32 5, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!185 = metadata !{i32 45, i32 5, metadata !186, null}
!186 = metadata !{i32 786443, metadata !1, metadata !184, i32 45, i32 5, i32 1, i32 26} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!187 = metadata !{i32 46, i32 3, metadata !188, null}
!188 = metadata !{i32 786443, metadata !1, metadata !184, i32 45, i32 32, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!189 = metadata !{i32 47, i32 3, metadata !188, null}
!190 = metadata !{i32 49, i32 2, metadata !11, null}
!191 = metadata !{i32 50, i32 2, metadata !11, null}
!192 = metadata !{i32 51, i32 2, metadata !11, null}
!193 = metadata !{i32 53, i32 1, metadata !11, null}
!194 = metadata !{i32 13, i32 7, metadata !195, null}
!195 = metadata !{i32 786443, metadata !19, metadata !18, i32 13, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c]
!196 = metadata !{i32 14, i32 5, metadata !195, null}
!197 = metadata !{i32 15, i32 1, metadata !18, null}
!198 = metadata !{i32 15, i32 3, metadata !29, null}
!199 = metadata !{i32 16, i32 3, metadata !29, null}
!200 = metadata !{metadata !201, metadata !201, i64 0}
!201 = metadata !{metadata !"int", metadata !202, i64 0}
!202 = metadata !{metadata !"omnipotent char", metadata !203, i64 0}
!203 = metadata !{metadata !"Simple C/C++ TBAA"}
!204 = metadata !{i32 21, i32 7, metadata !205, null}
!205 = metadata !{i32 786443, metadata !43, metadata !42, i32 21, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!206 = metadata !{i32 27, i32 5, metadata !207, null}
!207 = metadata !{i32 786443, metadata !43, metadata !205, i32 21, i32 26, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!208 = metadata !{i32 29, i32 1, metadata !42, null}
!209 = metadata !{i32 16, i32 7, metadata !210, null}
!210 = metadata !{i32 786443, metadata !55, metadata !54, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!211 = metadata !{i32 17, i32 5, metadata !210, null}
!212 = metadata !{i32 19, i32 7, metadata !213, null}
!213 = metadata !{i32 786443, metadata !55, metadata !54, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!214 = metadata !{i32 22, i32 5, metadata !215, null}
!215 = metadata !{i32 786443, metadata !55, metadata !213, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!216 = metadata !{i32 25, i32 9, metadata !217, null}
!217 = metadata !{i32 786443, metadata !55, metadata !215, i32 25, i32 9, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!218 = metadata !{i32 26, i32 7, metadata !219, null}
!219 = metadata !{i32 786443, metadata !55, metadata !217, i32 25, i32 19, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!220 = metadata !{i32 27, i32 5, metadata !219, null}
!221 = metadata !{i32 28, i32 7, metadata !222, null}
!222 = metadata !{i32 786443, metadata !55, metadata !217, i32 27, i32 12, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!223 = metadata !{i32 29, i32 7, metadata !222, null}
!224 = metadata !{i32 32, i32 5, metadata !215, null}
!225 = metadata !{i32 34, i32 1, metadata !54, null}
!226 = metadata !{i32 16, i32 3, metadata !227, null}
!227 = metadata !{i32 786443, metadata !68, metadata !67, i32 16, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c]
!228 = metadata !{i32 17, i32 5, metadata !67, null}
!229 = metadata !{metadata !202, metadata !202, i64 0}
!230 = metadata !{metadata !230, metadata !231, metadata !232}
!231 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!232 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!233 = metadata !{metadata !233, metadata !231, metadata !232}
!234 = metadata !{i32 18, i32 3, metadata !67, null}
!235 = metadata !{i32 16, i32 7, metadata !236, null}
!236 = metadata !{i32 786443, metadata !88, metadata !87, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!237 = metadata !{i32 19, i32 7, metadata !238, null}
!238 = metadata !{i32 786443, metadata !88, metadata !87, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!239 = metadata !{i32 20, i32 5, metadata !240, null}
!240 = metadata !{i32 786443, metadata !88, metadata !241, i32 20, i32 5, i32 3, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!241 = metadata !{i32 786443, metadata !88, metadata !242, i32 20, i32 5, i32 1, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!242 = metadata !{i32 786443, metadata !88, metadata !238, i32 19, i32 16, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!243 = metadata !{i32 20, i32 21, metadata !244, null}
!244 = metadata !{i32 786443, metadata !88, metadata !242, i32 20, i32 21, i32 2, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!245 = metadata !{metadata !245, metadata !231, metadata !232}
!246 = metadata !{metadata !246, metadata !231, metadata !232}
!247 = metadata !{i32 22, i32 5, metadata !248, null}
!248 = metadata !{i32 786443, metadata !88, metadata !238, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!249 = metadata !{i32 24, i32 5, metadata !250, null}
!250 = metadata !{i32 786443, metadata !88, metadata !251, i32 24, i32 5, i32 3, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!251 = metadata !{i32 786443, metadata !88, metadata !248, i32 24, i32 5, i32 1, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!252 = metadata !{i32 23, i32 5, metadata !248, null}
!253 = metadata !{i32 24, i32 21, metadata !254, null}
!254 = metadata !{i32 786443, metadata !88, metadata !248, i32 24, i32 21, i32 2, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!255 = metadata !{metadata !255, metadata !231, metadata !232}
!256 = metadata !{metadata !256, metadata !231, metadata !232}
!257 = metadata !{i32 28, i32 1, metadata !87, null}
!258 = metadata !{i32 15, i32 3, metadata !259, null}
!259 = metadata !{i32 786443, metadata !100, metadata !99, i32 15, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c]
!260 = metadata !{i32 16, i32 5, metadata !99, null}
!261 = metadata !{metadata !261, metadata !231, metadata !232}
!262 = metadata !{metadata !262, metadata !231, metadata !232}
!263 = metadata !{i32 17, i32 3, metadata !99, null}
!264 = metadata !{i32 13, i32 5, metadata !265, null}
!265 = metadata !{i32 786443, metadata !112, metadata !111, i32 13, i32 5, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c]
!266 = metadata !{i32 14, i32 7, metadata !111, null}
!267 = metadata !{i32 15, i32 5, metadata !111, null}
