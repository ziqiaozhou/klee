; ModuleID = 'hash.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [10 x i8] c"n=%d,m=%d\00", align 1
@.str1 = private unnamed_addr constant [15 x i8] c"%d,%d,%d,%s & \00", align 1
@.str2 = private unnamed_addr constant [5 x i8] c"%s =\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str4 = private unnamed_addr constant [8 x i8] c"xor=%d,\00", align 1
@.str5 = private unnamed_addr constant [13 x i8] c"result_i=%d\0A\00", align 1
@.str6 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str7 = private unnamed_addr constant [13 x i8] c"result alert\00", align 1
@.str8 = private unnamed_addr constant [4 x i8] c"%lx\00", align 1
@.str9 = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str110 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str211 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1
@.str312 = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str25 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1
@.str613 = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private unnamed_addr constant [14 x i8] c"invalid range\00", align 1
@.str28 = private unnamed_addr constant [5 x i8] c"user\00", align 1

; Function Attrs: nounwind uwtable
define i8* @int2bin(i32 %a, i8* %buffer, i32 %buf_size) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %a, i32* %1, align 4
  store i8* %buffer, i8** %2, align 8
  store i32 %buf_size, i32* %3, align 4
  %4 = load i8** %2, align 8, !dbg !129
  %5 = load i32* %3, align 4, !dbg !129
  %6 = sext i32 %5 to i64, !dbg !129
  %7 = call i8* @memset(i8* %4, i32 0, i64 %6)
  %8 = load i32* %3, align 4, !dbg !130
  %9 = sub nsw i32 %8, 1, !dbg !130
  %10 = load i8** %2, align 8, !dbg !130
  %11 = sext i32 %9 to i64, !dbg !130
  %12 = getelementptr inbounds i8* %10, i64 %11, !dbg !130
  store i8* %12, i8** %2, align 8, !dbg !130
  store i32 31, i32* %i, align 4, !dbg !131
  br label %13, !dbg !131

; <label>:13                                      ; preds = %16, %0
  %14 = load i32* %i, align 4, !dbg !133
  %15 = icmp sge i32 %14, 0, !dbg !133
  br i1 %15, label %16, label %27, !dbg !133

; <label>:16                                      ; preds = %13
  %17 = load i32* %1, align 4, !dbg !136
  %18 = and i32 %17, 1, !dbg !136
  %19 = add nsw i32 %18, 48, !dbg !136
  %20 = trunc i32 %19 to i8, !dbg !136
  %21 = load i8** %2, align 8, !dbg !136
  %22 = getelementptr inbounds i8* %21, i32 -1, !dbg !136
  store i8* %22, i8** %2, align 8, !dbg !136
  store i8 %20, i8* %21, align 1, !dbg !136
  %23 = load i32* %1, align 4, !dbg !138
  %int_cast_to_i64 = zext i32 1 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i64), !dbg !138
  %24 = ashr i32 %23, 1, !dbg !138
  store i32 %24, i32* %1, align 4, !dbg !138
  %25 = load i32* %i, align 4, !dbg !139
  %26 = add nsw i32 %25, -1, !dbg !139
  store i32 %26, i32* %i, align 4, !dbg !139
  br label %13, !dbg !139

; <label>:27                                      ; preds = %13
  %28 = load i8** %2, align 8, !dbg !140
  ret i8* %28, !dbg !140
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #2

; Function Attrs: nounwind uwtable
define i8* @hash(i8* %result0, i8* %key0, i8* %data0, i32 %n, i32 %m) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %key = alloca i8*, align 8
  %data = alloca i8*, align 8
  %result = alloca i8*, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %l = alloca i32, align 4
  %onebit = alloca i8, align 1
  %aAndy = alloca i8, align 1
  %axory = alloca i8, align 1
  %aAndy0 = alloca i8, align 1
  %axory1 = alloca i8, align 1
  %buffer = alloca [33 x i8], align 16
  %result_i_ptr = alloca i8*, align 8
  %y = alloca i8, align 1
  %a = alloca i8, align 1
  store i8* %result0, i8** %2, align 8
  store i8* %key0, i8** %3, align 8
  store i8* %data0, i8** %4, align 8
  store i32 %n, i32* %5, align 4
  store i32 %m, i32* %6, align 4
  %7 = load i8** %3, align 8, !dbg !141
  store i8* %7, i8** %key, align 8, !dbg !141
  %8 = load i8** %4, align 8, !dbg !142
  store i8* %8, i8** %data, align 8, !dbg !142
  %9 = load i8** %2, align 8, !dbg !143
  store i8* %9, i8** %result, align 8, !dbg !143
  %10 = load i32* %5, align 4, !dbg !144
  %11 = icmp sle i32 %10, 0, !dbg !144
  %12 = load i8** %data, align 8
  %13 = icmp eq i8* %12, null, !dbg !146
  %or.cond = or i1 %11, %13, !dbg !144
  br i1 %or.cond, label %14, label %15, !dbg !144

; <label>:14                                      ; preds = %0
  store i8* null, i8** %1, !dbg !148
  br label %128, !dbg !148

; <label>:15                                      ; preds = %0
  %16 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i64 32, !dbg !151
  store i8 0, i8* %16, align 1, !dbg !151
  %17 = load i32* %5, align 4, !dbg !152
  %18 = load i32* %6, align 4, !dbg !152
  %19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str, i32 0, i32 0), i32 %17, i32 %18), !dbg !152
  store i32 0, i32* %i, align 4, !dbg !153
  br label %20, !dbg !153

; <label>:20                                      ; preds = %125, %15
  %21 = load i32* %i, align 4, !dbg !155
  %22 = load i32* %6, align 4, !dbg !155
  %23 = icmp slt i32 %21, %22, !dbg !155
  br i1 %23, label %24, label %128, !dbg !155

; <label>:24                                      ; preds = %20
  %25 = load i32* %i, align 4, !dbg !158
  %26 = sext i32 %25 to i64, !dbg !158
  %27 = load i8** %result, align 8, !dbg !158
  %28 = getelementptr inbounds i8* %27, i64 %26, !dbg !158
  store i8* %28, i8** %result_i_ptr, align 8, !dbg !158
  store i32 0, i32* %k, align 4, !dbg !160
  br label %29, !dbg !160

; <label>:29                                      ; preds = %107, %24
  %30 = load i32* %k, align 4, !dbg !162
  %31 = icmp slt i32 %30, 8, !dbg !162
  br i1 %31, label %32, label %125, !dbg !162

; <label>:32                                      ; preds = %29
  %33 = load i8** %data, align 8, !dbg !165
  %34 = getelementptr inbounds i8* %33, i64 0, !dbg !165
  %35 = load i8* %34, align 1, !dbg !165
  %36 = zext i8 %35 to i32, !dbg !165
  %37 = and i32 1, %36, !dbg !165
  %38 = trunc i32 %37 to i8, !dbg !165
  store i8 %38, i8* %axory, align 1, !dbg !165
  store i32 0, i32* %l, align 4, !dbg !167
  br label %39, !dbg !167

; <label>:39                                      ; preds = %104, %32
  %40 = load i32* %l, align 4, !dbg !169
  %41 = load i32* %5, align 4, !dbg !169
  %42 = icmp slt i32 %40, %41, !dbg !169
  br i1 %42, label %43, label %107, !dbg !169

; <label>:43                                      ; preds = %39
  %44 = load i32* %l, align 4, !dbg !172
  %45 = sext i32 %44 to i64, !dbg !172
  %46 = load i8** %data, align 8, !dbg !172
  %47 = getelementptr inbounds i8* %46, i64 %45, !dbg !172
  %48 = load i8* %47, align 1, !dbg !172
  store i8 %48, i8* %y, align 1, !dbg !172
  %49 = load i32* %k, align 4, !dbg !174
  %50 = load i32* %i, align 4, !dbg !174
  %51 = mul nsw i32 8, %50, !dbg !174
  %52 = add nsw i32 %49, %51, !dbg !174
  %53 = mul nsw i32 %52, 4, !dbg !174
  %54 = load i32* %l, align 4, !dbg !174
  %55 = add nsw i32 %53, %54, !dbg !174
  %56 = sext i32 %55 to i64, !dbg !174
  %57 = load i8** %key, align 8, !dbg !174
  %58 = getelementptr inbounds i8* %57, i64 %56, !dbg !174
  %59 = load i8* %58, align 1, !dbg !174
  store i8 %59, i8* %a, align 1, !dbg !174
  %60 = load i8* %a, align 1, !dbg !175
  %61 = zext i8 %60 to i32, !dbg !175
  %62 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !175
  %63 = call i8* @int2bin(i32 %61, i8* %62, i32 32), !dbg !175
  %64 = load i32* %i, align 4, !dbg !176
  %65 = load i32* %k, align 4, !dbg !176
  %66 = load i32* %l, align 4, !dbg !176
  %67 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !176
  %68 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([15 x i8]* @.str1, i32 0, i32 0), i32 %64, i32 %65, i32 %66, i8* %67), !dbg !176
  %69 = load i8* %y, align 1, !dbg !177
  %70 = zext i8 %69 to i32, !dbg !177
  %71 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !177
  %72 = call i8* @int2bin(i32 %70, i8* %71, i32 32), !dbg !177
  %73 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !178
  %74 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str2, i32 0, i32 0), i8* %73), !dbg !178
  %75 = load i8* %a, align 1, !dbg !179
  %76 = zext i8 %75 to i32, !dbg !179
  %77 = load i8* %y, align 1, !dbg !179
  %78 = zext i8 %77 to i32, !dbg !179
  %79 = and i32 %76, %78, !dbg !179
  %80 = trunc i32 %79 to i8, !dbg !179
  store i8 %80, i8* %aAndy, align 1, !dbg !179
  %81 = load i8* %aAndy, align 1, !dbg !180
  %82 = zext i8 %81 to i32, !dbg !180
  %83 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !180
  %84 = call i8* @int2bin(i32 %82, i8* %83, i32 32), !dbg !180
  %85 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !181
  %86 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str3, i32 0, i32 0), i8* %85), !dbg !181
  store i32 0, i32* %j, align 4, !dbg !182
  br label %87, !dbg !182

; <label>:87                                      ; preds = %90, %43
  %88 = load i32* %j, align 4, !dbg !184
  %89 = icmp slt i32 %88, 8, !dbg !184
  br i1 %89, label %90, label %104, !dbg !184

; <label>:90                                      ; preds = %87
  %91 = load i8* %aAndy, align 1, !dbg !187
  %92 = zext i8 %91 to i32, !dbg !187
  %93 = and i32 %92, 1, !dbg !187
  %94 = load i8* %axory, align 1, !dbg !187
  %95 = zext i8 %94 to i32, !dbg !187
  %96 = xor i32 %95, %93, !dbg !187
  %97 = trunc i32 %96 to i8, !dbg !187
  store i8 %97, i8* %axory, align 1, !dbg !187
  %98 = load i8* %aAndy, align 1, !dbg !189
  %99 = zext i8 %98 to i32, !dbg !189
  %int_cast_to_i64 = zext i32 1 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i64), !dbg !189
  %100 = ashr i32 %99, 1, !dbg !189
  %101 = trunc i32 %100 to i8, !dbg !189
  store i8 %101, i8* %aAndy, align 1, !dbg !189
  %102 = load i32* %j, align 4, !dbg !190
  %103 = add nsw i32 %102, 1, !dbg !190
  store i32 %103, i32* %j, align 4, !dbg !190
  br label %87, !dbg !190

; <label>:104                                     ; preds = %87
  %105 = load i32* %l, align 4, !dbg !191
  %106 = add nsw i32 %105, 1, !dbg !191
  store i32 %106, i32* %l, align 4, !dbg !191
  br label %39, !dbg !191

; <label>:107                                     ; preds = %39
  %108 = load i8* %axory, align 1, !dbg !192
  %109 = zext i8 %108 to i32, !dbg !192
  %110 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str4, i32 0, i32 0), i32 %109), !dbg !192
  %111 = load i8* %axory, align 1, !dbg !193
  %112 = zext i8 %111 to i32, !dbg !193
  %113 = load i32* %i, align 4, !dbg !193
  %int_cast_to_i641 = zext i32 %113 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i641), !dbg !193
  %114 = shl i32 %112, %113, !dbg !193
  %115 = load i8** %result_i_ptr, align 8, !dbg !193
  %116 = load i8* %115, align 1, !dbg !193
  %117 = zext i8 %116 to i32, !dbg !193
  %118 = or i32 %117, %114, !dbg !193
  %119 = trunc i32 %118 to i8, !dbg !193
  store i8 %119, i8* %115, align 1, !dbg !193
  %120 = load i8* %axory, align 1, !dbg !194
  %121 = zext i8 %120 to i32, !dbg !194
  %122 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str5, i32 0, i32 0), i32 %121), !dbg !194
  %123 = load i32* %k, align 4, !dbg !195
  %124 = add nsw i32 %123, 1, !dbg !195
  store i32 %124, i32* %k, align 4, !dbg !195
  br label %29, !dbg !195

; <label>:125                                     ; preds = %29
  %126 = load i32* %i, align 4, !dbg !196
  %127 = add nsw i32 %126, 1, !dbg !196
  store i32 %127, i32* %i, align 4, !dbg !196
  br label %20, !dbg !196

; <label>:128                                     ; preds = %20, %14
  %129 = load i8** %1, !dbg !197
  ret i8* %129, !dbg !197
}

declare i32 @printf(i8*, ...) #3

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %key = alloca [96 x i8], align 16
  %keyb = alloca i8*, align 8
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  %data = alloca [4 x i8], align 1
  %result = alloca i64, align 8
  %idata = alloca i32, align 4
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 4, i32* %n, align 4, !dbg !198
  store i32 3, i32* %m, align 4, !dbg !198
  %4 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !199
  store i8* %4, i8** %keyb, align 8, !dbg !199
  store i32 715826517, i32* %x, align 4, !dbg !200
  store i32 0, i32* %i, align 4, !dbg !201
  br label %5, !dbg !201

; <label>:5                                       ; preds = %8, %0
  %6 = load i32* %i, align 4, !dbg !203
  %7 = icmp slt i32 %6, 24, !dbg !203
  br i1 %7, label %8, label %17, !dbg !203

; <label>:8                                       ; preds = %5
  %9 = load i32* %i, align 4, !dbg !206
  %10 = mul nsw i32 %9, 4, !dbg !206
  %11 = sext i32 %10 to i64, !dbg !206
  %12 = getelementptr inbounds [96 x i8]* %key, i32 0, i64 %11, !dbg !206
  %13 = bitcast i32* %x to i8*, !dbg !206
  %14 = call i8* @memcpy(i8* %12, i8* %13, i64 4)
  %15 = load i32* %i, align 4, !dbg !208
  %16 = add nsw i32 %15, 1, !dbg !208
  store i32 %16, i32* %i, align 4, !dbg !208
  br label %5, !dbg !208

; <label>:17                                      ; preds = %5
  %18 = call i32 (i32*, i32, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i32*, i32, i8*, ...)*)(i32* %idata, i32 4, i8* getelementptr inbounds ([2 x i8]* @.str6, i32 0, i32 0)), !dbg !209
  %19 = bitcast i64* %result to i8*, !dbg !210
  %20 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !210
  %21 = bitcast i32* %idata to i8*, !dbg !210
  %22 = load i32* %n, align 4, !dbg !210
  %23 = mul nsw i32 %22, 8, !dbg !210
  %int_cast_to_i64 = zext i32 8 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i64), !dbg !210
  %24 = sdiv i32 %23, 8, !dbg !210
  %25 = load i32* %m, align 4, !dbg !210
  %26 = mul nsw i32 %25, 8, !dbg !210
  %int_cast_to_i641 = zext i32 8 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i641), !dbg !210
  %27 = sdiv i32 %26, 8, !dbg !210
  %28 = call i8* @hash(i8* %19, i8* %20, i8* %21, i32 %24, i32 %27), !dbg !210
  %29 = load i64* %result, align 8, !dbg !211
  %30 = icmp ult i64 %29, 10000, !dbg !211
  br i1 %30, label %31, label %33, !dbg !211

; <label>:31                                      ; preds = %17
  %32 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str7, i32 0, i32 0)), !dbg !213
  store i32 1, i32* %1, !dbg !215
  br label %36, !dbg !215

; <label>:33                                      ; preds = %17
  %34 = load i64* %result, align 8, !dbg !216
  %35 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str8, i32 0, i32 0), i64 %34), !dbg !216
  store i32 1, i32* %1, !dbg !217
  br label %36, !dbg !217

; <label>:36                                      ; preds = %33, %31
  %37 = load i32* %1, !dbg !218
  ret i32 %37, !dbg !218
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

declare i32 @klee_make_symbolic(...) #3

; Function Attrs: nounwind ssp uwtable
define void @klee_div_zero_check(i64 %z) #4 {
  %1 = icmp eq i64 %z, 0, !dbg !219
  br i1 %1, label %2, label %3, !dbg !219

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str9, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str110, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str211, i64 0, i64 0)) #7, !dbg !221
  unreachable, !dbg !221

; <label>:3                                       ; preds = %0
  ret void, !dbg !222
}

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #5

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #1

; Function Attrs: nounwind ssp uwtable
define i32 @klee_int(i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = bitcast i32* %x to i8*, !dbg !223
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %1, i64 4, i8* %name) #8, !dbg !223
  %2 = load i32* %x, align 4, !dbg !224, !tbaa !225
  ret i32 %2, !dbg !224
}

; Function Attrs: nounwind ssp uwtable
define void @klee_overshift_check(i64 %bitWidth, i64 %shift) #4 {
  %1 = icmp ult i64 %shift, %bitWidth, !dbg !229
  br i1 %1, label %3, label %2, !dbg !229

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str312, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) #7, !dbg !231
  unreachable, !dbg !231

; <label>:3                                       ; preds = %0
  ret void, !dbg !233
}

; Function Attrs: nounwind ssp uwtable
define i32 @klee_range(i32 %start, i32 %end, i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = icmp slt i32 %start, %end, !dbg !234
  br i1 %1, label %3, label %2, !dbg !234

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str613, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) #7, !dbg !236
  unreachable, !dbg !236

; <label>:3                                       ; preds = %0
  %4 = add nsw i32 %start, 1, !dbg !237
  %5 = icmp eq i32 %4, %end, !dbg !237
  br i1 %5, label %21, label %6, !dbg !237

; <label>:6                                       ; preds = %3
  %7 = bitcast i32* %x to i8*, !dbg !239
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %7, i64 4, i8* %name) #8, !dbg !239
  %8 = icmp eq i32 %start, 0, !dbg !241
  %9 = load i32* %x, align 4, !dbg !243, !tbaa !225
  br i1 %8, label %10, label %13, !dbg !241

; <label>:10                                      ; preds = %6
  %11 = icmp ult i32 %9, %end, !dbg !243
  %12 = zext i1 %11 to i64, !dbg !243
  call void @klee_assume(i64 %12) #8, !dbg !243
  br label %19, !dbg !245

; <label>:13                                      ; preds = %6
  %14 = icmp sge i32 %9, %start, !dbg !246
  %15 = zext i1 %14 to i64, !dbg !246
  call void @klee_assume(i64 %15) #8, !dbg !246
  %16 = load i32* %x, align 4, !dbg !248, !tbaa !225
  %17 = icmp slt i32 %16, %end, !dbg !248
  %18 = zext i1 %17 to i64, !dbg !248
  call void @klee_assume(i64 %18) #8, !dbg !248
  br label %19

; <label>:19                                      ; preds = %13, %10
  %20 = load i32* %x, align 4, !dbg !249, !tbaa !225
  br label %21, !dbg !249

; <label>:21                                      ; preds = %19, %3
  %.0 = phi i32 [ %20, %19 ], [ %start, %3 ]
  ret i32 %.0, !dbg !250
}

declare void @klee_assume(i64) #6

; Function Attrs: nounwind ssp uwtable
define weak i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !251
  br i1 %1, label %._crit_edge, label %overflow.checked, !dbg !251

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
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !253
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !253, !tbaa !254
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !253
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !253
  %wide.load202.unr = load <16 x i8>* %8, align 1, !dbg !253, !tbaa !254
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !253, !tbaa !254
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !253
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load202.unr, <16 x i8>* %11, align 1, !dbg !253, !tbaa !254
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep105 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !253
  %wide.load = load <16 x i8>* %13, align 1, !dbg !253, !tbaa !254
  %next.gep.sum281 = or i64 %index, 16, !dbg !253
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum281, !dbg !253
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !253
  %wide.load202 = load <16 x i8>* %15, align 1, !dbg !253, !tbaa !254
  %16 = bitcast i8* %next.gep105 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !253, !tbaa !254
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum281, !dbg !253
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load202, <16 x i8>* %18, align 1, !dbg !253, !tbaa !254
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep105.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !253
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !253, !tbaa !254
  %next.gep.sum281.1 = or i64 %index.next, 16, !dbg !253
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum281.1, !dbg !253
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !253
  %wide.load202.1 = load <16 x i8>* %21, align 1, !dbg !253, !tbaa !254
  %22 = bitcast i8* %next.gep105.1 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !253, !tbaa !254
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum281.1, !dbg !253
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !253
  store <16 x i8> %wide.load202.1, <16 x i8>* %24, align 1, !dbg !253, !tbaa !254
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !255

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
  %26 = add i64 %resume.val8, -1, !dbg !251
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !253
  %28 = load i8* %resume.val, align 1, !dbg !253, !tbaa !254
  %29 = getelementptr inbounds i8* %resume.val5, i64 1, !dbg !253
  store i8 %28, i8* %resume.val5, align 1, !dbg !253, !tbaa !254
  br label %.lr.ph.unr299

.lr.ph.unr299:                                    ; preds = %.lr.ph.unr, %unr.cmp304
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val8, %unr.cmp304 ]
  %30 = add i64 %.01.unr, -1, !dbg !251
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !253
  %32 = load i8* %src.03.unr, align 1, !dbg !253, !tbaa !254
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !253
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !253, !tbaa !254
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr299, %unr.cmp304
  %src.03.unr301 = phi i8* [ %31, %.lr.ph.unr299 ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr302 = phi i8* [ %33, %.lr.ph.unr299 ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr303 = phi i64 [ %30, %.lr.ph.unr299 ], [ %resume.val8, %unr.cmp304 ]
  %34 = add i64 %.01.unr303, -1, !dbg !251
  %35 = getelementptr inbounds i8* %src.03.unr301, i64 1, !dbg !253
  %36 = load i8* %src.03.unr301, align 1, !dbg !253, !tbaa !254
  %37 = getelementptr inbounds i8* %dest.02.unr302, i64 1, !dbg !253
  store i8 %36, i8* %dest.02.unr302, align 1, !dbg !253, !tbaa !254
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
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !253
  %40 = load i8* %src.03, align 1, !dbg !253, !tbaa !254
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !253
  store i8 %40, i8* %dest.02, align 1, !dbg !253, !tbaa !254
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !253
  %43 = load i8* %39, align 1, !dbg !253, !tbaa !254
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !253
  store i8 %43, i8* %41, align 1, !dbg !253, !tbaa !254
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !253
  %46 = load i8* %42, align 1, !dbg !253, !tbaa !254
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !253
  store i8 %46, i8* %44, align 1, !dbg !253, !tbaa !254
  %48 = add i64 %.01, -4, !dbg !251
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !253
  %50 = load i8* %45, align 1, !dbg !253, !tbaa !254
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !253
  store i8 %50, i8* %47, align 1, !dbg !253, !tbaa !254
  %52 = icmp eq i64 %48, 0, !dbg !251
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !251, !llvm.loop !258

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block, %0
  ret i8* %destaddr, !dbg !259
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memmove(i8* %dst, i8* %src, i64 %count) #4 {
  %1 = icmp eq i8* %src, %dst, !dbg !260
  br i1 %1, label %.loopexit, label %2, !dbg !260

; <label>:2                                       ; preds = %0
  %3 = icmp ugt i8* %src, %dst, !dbg !262
  br i1 %3, label %.preheader, label %56, !dbg !262

.preheader:                                       ; preds = %2
  %4 = icmp eq i64 %count, 0, !dbg !264
  br i1 %4, label %.loopexit, label %overflow.checked227, !dbg !264

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
  %9 = bitcast i8* %src to <16 x i8>*, !dbg !268
  %wide.load445.unr = load <16 x i8>* %9, align 1, !dbg !268, !tbaa !254
  %10 = getelementptr i8* %src, i64 16, !dbg !268
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !268
  %wide.load446.unr = load <16 x i8>* %11, align 1, !dbg !268, !tbaa !254
  %12 = bitcast i8* %dst to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load445.unr, <16 x i8>* %12, align 1, !dbg !268, !tbaa !254
  %13 = getelementptr i8* %dst, i64 16, !dbg !268
  %14 = bitcast i8* %13 to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load446.unr, <16 x i8>* %14, align 1, !dbg !268, !tbaa !254
  br label %vector.body218.preheader.split

vector.body218.preheader.split:                   ; preds = %vector.body218.unr, %vector.body218.preheader
  %index221.unr = phi i64 [ 0, %vector.body218.preheader ], [ 32, %vector.body218.unr ]
  %15 = icmp ult i64 %8, 2
  br i1 %15, label %middle.block219, label %vector.body218

vector.body218:                                   ; preds = %vector.body218.preheader.split, %vector.body218
  %index221 = phi i64 [ %index.next245.1, %vector.body218 ], [ %index221.unr, %vector.body218.preheader.split ]
  %next.gep247 = getelementptr i8* %src, i64 %index221
  %next.gep344 = getelementptr i8* %dst, i64 %index221
  %16 = bitcast i8* %next.gep247 to <16 x i8>*, !dbg !268
  %wide.load445 = load <16 x i8>* %16, align 1, !dbg !268, !tbaa !254
  %next.gep247.sum594 = or i64 %index221, 16, !dbg !268
  %17 = getelementptr i8* %src, i64 %next.gep247.sum594, !dbg !268
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !268
  %wide.load446 = load <16 x i8>* %18, align 1, !dbg !268, !tbaa !254
  %19 = bitcast i8* %next.gep344 to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load445, <16 x i8>* %19, align 1, !dbg !268, !tbaa !254
  %20 = getelementptr i8* %dst, i64 %next.gep247.sum594, !dbg !268
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load446, <16 x i8>* %21, align 1, !dbg !268, !tbaa !254
  %index.next245 = add i64 %index221, 32
  %next.gep247.1 = getelementptr i8* %src, i64 %index.next245
  %next.gep344.1 = getelementptr i8* %dst, i64 %index.next245
  %22 = bitcast i8* %next.gep247.1 to <16 x i8>*, !dbg !268
  %wide.load445.1 = load <16 x i8>* %22, align 1, !dbg !268, !tbaa !254
  %next.gep247.sum594.1 = or i64 %index.next245, 16, !dbg !268
  %23 = getelementptr i8* %src, i64 %next.gep247.sum594.1, !dbg !268
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !268
  %wide.load446.1 = load <16 x i8>* %24, align 1, !dbg !268, !tbaa !254
  %25 = bitcast i8* %next.gep344.1 to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load445.1, <16 x i8>* %25, align 1, !dbg !268, !tbaa !254
  %26 = getelementptr i8* %dst, i64 %next.gep247.sum594.1, !dbg !268
  %27 = bitcast i8* %26 to <16 x i8>*, !dbg !268
  store <16 x i8> %wide.load446.1, <16 x i8>* %27, align 1, !dbg !268, !tbaa !254
  %index.next245.1 = add i64 %index221, 64
  %28 = icmp eq i64 %index.next245.1, %n.vec224
  br i1 %28, label %middle.block219, label %vector.body218, !llvm.loop !270

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
  %29 = add i64 %resume.val240, -1, !dbg !264
  %30 = getelementptr inbounds i8* %resume.val235, i64 1, !dbg !268
  %31 = load i8* %resume.val235, align 1, !dbg !268, !tbaa !254
  %32 = getelementptr inbounds i8* %resume.val237, i64 1, !dbg !268
  store i8 %31, i8* %resume.val237, align 1, !dbg !268, !tbaa !254
  br label %.lr.ph.unr613

.lr.ph.unr613:                                    ; preds = %.lr.ph.unr, %unr.cmp618
  %b.05.unr = phi i8* [ %30, %.lr.ph.unr ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr = phi i8* [ %32, %.lr.ph.unr ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr = phi i64 [ %29, %.lr.ph.unr ], [ %resume.val240, %unr.cmp618 ]
  %33 = add i64 %.03.unr, -1, !dbg !264
  %34 = getelementptr inbounds i8* %b.05.unr, i64 1, !dbg !268
  %35 = load i8* %b.05.unr, align 1, !dbg !268, !tbaa !254
  %36 = getelementptr inbounds i8* %a.04.unr, i64 1, !dbg !268
  store i8 %35, i8* %a.04.unr, align 1, !dbg !268, !tbaa !254
  br label %.lr.ph.unr614

.lr.ph.unr614:                                    ; preds = %.lr.ph.unr613, %unr.cmp618
  %b.05.unr615 = phi i8* [ %34, %.lr.ph.unr613 ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr616 = phi i8* [ %36, %.lr.ph.unr613 ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr617 = phi i64 [ %33, %.lr.ph.unr613 ], [ %resume.val240, %unr.cmp618 ]
  %37 = add i64 %.03.unr617, -1, !dbg !264
  %38 = getelementptr inbounds i8* %b.05.unr615, i64 1, !dbg !268
  %39 = load i8* %b.05.unr615, align 1, !dbg !268, !tbaa !254
  %40 = getelementptr inbounds i8* %a.04.unr616, i64 1, !dbg !268
  store i8 %39, i8* %a.04.unr616, align 1, !dbg !268, !tbaa !254
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
  %42 = getelementptr inbounds i8* %b.05, i64 1, !dbg !268
  %43 = load i8* %b.05, align 1, !dbg !268, !tbaa !254
  %44 = getelementptr inbounds i8* %a.04, i64 1, !dbg !268
  store i8 %43, i8* %a.04, align 1, !dbg !268, !tbaa !254
  %45 = getelementptr inbounds i8* %b.05, i64 2, !dbg !268
  %46 = load i8* %42, align 1, !dbg !268, !tbaa !254
  %47 = getelementptr inbounds i8* %a.04, i64 2, !dbg !268
  store i8 %46, i8* %44, align 1, !dbg !268, !tbaa !254
  %48 = getelementptr inbounds i8* %b.05, i64 3, !dbg !268
  %49 = load i8* %45, align 1, !dbg !268, !tbaa !254
  %50 = getelementptr inbounds i8* %a.04, i64 3, !dbg !268
  store i8 %49, i8* %47, align 1, !dbg !268, !tbaa !254
  %51 = add i64 %.03, -4, !dbg !264
  %52 = getelementptr inbounds i8* %b.05, i64 4, !dbg !268
  %53 = load i8* %48, align 1, !dbg !268, !tbaa !254
  %54 = getelementptr inbounds i8* %a.04, i64 4, !dbg !268
  store i8 %53, i8* %50, align 1, !dbg !268, !tbaa !254
  %55 = icmp eq i64 %51, 0, !dbg !264
  br i1 %55, label %.loopexit, label %.lr.ph, !dbg !264, !llvm.loop !271

; <label>:56                                      ; preds = %2
  %57 = add i64 %count, -1, !dbg !272
  %58 = icmp eq i64 %count, 0, !dbg !274
  br i1 %58, label %.loopexit, label %.lr.ph9, !dbg !274

.lr.ph9:                                          ; preds = %56
  %59 = getelementptr inbounds i8* %src, i64 %57, !dbg !277
  %60 = getelementptr inbounds i8* %dst, i64 %57, !dbg !272
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
  %next.gep.sum = add i64 %.sum448, -15, !dbg !278
  %61 = getelementptr i8* %src, i64 %next.gep.sum, !dbg !278
  %62 = bitcast i8* %61 to <16 x i8>*, !dbg !278
  %wide.load = load <16 x i8>* %62, align 1, !dbg !278, !tbaa !254
  %.sum513 = add i64 %.sum448, -31, !dbg !278
  %63 = getelementptr i8* %src, i64 %.sum513, !dbg !278
  %64 = bitcast i8* %63 to <16 x i8>*, !dbg !278
  %wide.load211 = load <16 x i8>* %64, align 1, !dbg !278, !tbaa !254
  %65 = getelementptr i8* %dst, i64 %next.gep.sum, !dbg !278
  %66 = bitcast i8* %65 to <16 x i8>*, !dbg !278
  store <16 x i8> %wide.load, <16 x i8>* %66, align 1, !dbg !278, !tbaa !254
  %67 = getelementptr i8* %dst, i64 %.sum513, !dbg !278
  %68 = bitcast i8* %67 to <16 x i8>*, !dbg !278
  store <16 x i8> %wide.load211, <16 x i8>* %68, align 1, !dbg !278, !tbaa !254
  %index.next = add i64 %index, 32
  %69 = icmp eq i64 %index.next, %n.vec
  br i1 %69, label %middle.block, label %vector.body, !llvm.loop !280

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
  %71 = add i64 %resume.val16, -1, !dbg !274
  %.sum1 = add i64 %70, -1, !dbg !278
  %72 = getelementptr inbounds i8* %src, i64 %.sum1, !dbg !278
  %73 = load i8* %resume.val, align 1, !dbg !278, !tbaa !254
  %74 = getelementptr inbounds i8* %dst, i64 %.sum1, !dbg !278
  store i8 %73, i8* %resume.val12, align 1, !dbg !278, !tbaa !254
  br label %scalar.ph.unr631

scalar.ph.unr631:                                 ; preds = %scalar.ph.unr, %unr.cmp638
  %b.18.unr = phi i8* [ %72, %scalar.ph.unr ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr = phi i8* [ %74, %scalar.ph.unr ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr = phi i64 [ %71, %scalar.ph.unr ], [ %resume.val16, %unr.cmp638 ]
  %75 = add i64 %.16.unr, -1, !dbg !274
  %76 = getelementptr inbounds i8* %b.18.unr, i64 -1, !dbg !278
  %77 = load i8* %b.18.unr, align 1, !dbg !278, !tbaa !254
  %78 = getelementptr inbounds i8* %a.17.unr, i64 -1, !dbg !278
  store i8 %77, i8* %a.17.unr, align 1, !dbg !278, !tbaa !254
  br label %scalar.ph.unr634

scalar.ph.unr634:                                 ; preds = %scalar.ph.unr631, %unr.cmp638
  %b.18.unr635 = phi i8* [ %76, %scalar.ph.unr631 ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr636 = phi i8* [ %78, %scalar.ph.unr631 ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr637 = phi i64 [ %75, %scalar.ph.unr631 ], [ %resume.val16, %unr.cmp638 ]
  %79 = add i64 %.16.unr637, -1, !dbg !274
  %80 = getelementptr inbounds i8* %b.18.unr635, i64 -1, !dbg !278
  %81 = load i8* %b.18.unr635, align 1, !dbg !278, !tbaa !254
  %82 = getelementptr inbounds i8* %a.17.unr636, i64 -1, !dbg !278
  store i8 %81, i8* %a.17.unr636, align 1, !dbg !278, !tbaa !254
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
  %84 = getelementptr inbounds i8* %b.18, i64 -1, !dbg !278
  %85 = load i8* %b.18, align 1, !dbg !278, !tbaa !254
  %86 = getelementptr inbounds i8* %a.17, i64 -1, !dbg !278
  store i8 %85, i8* %a.17, align 1, !dbg !278, !tbaa !254
  %87 = getelementptr inbounds i8* %b.18, i64 -2, !dbg !278
  %88 = load i8* %84, align 1, !dbg !278, !tbaa !254
  %89 = getelementptr inbounds i8* %a.17, i64 -2, !dbg !278
  store i8 %88, i8* %86, align 1, !dbg !278, !tbaa !254
  %90 = getelementptr inbounds i8* %b.18, i64 -3, !dbg !278
  %91 = load i8* %87, align 1, !dbg !278, !tbaa !254
  %92 = getelementptr inbounds i8* %a.17, i64 -3, !dbg !278
  store i8 %91, i8* %89, align 1, !dbg !278, !tbaa !254
  %93 = add i64 %.16, -4, !dbg !274
  %94 = getelementptr inbounds i8* %b.18, i64 -4, !dbg !278
  %95 = load i8* %90, align 1, !dbg !278, !tbaa !254
  %96 = getelementptr inbounds i8* %a.17, i64 -4, !dbg !278
  store i8 %95, i8* %92, align 1, !dbg !278, !tbaa !254
  %97 = icmp eq i64 %93, 0, !dbg !274
  br i1 %97, label %.loopexit, label %scalar.ph, !dbg !274, !llvm.loop !281

.loopexit:                                        ; preds = %scalar.ph, %.lr.ph, %scalar.ph.preheader.split, %middle.block, %56, %.lr.ph.preheader.split, %middle.block219, %.preheader, %0
  ret i8* %dst, !dbg !282
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !283
  br i1 %1, label %53, label %overflow.checked, !dbg !283

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
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !285
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !285, !tbaa !254
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !285
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !285
  %wide.load203.unr = load <16 x i8>* %8, align 1, !dbg !285, !tbaa !254
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !285, !tbaa !254
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !285
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load203.unr, <16 x i8>* %11, align 1, !dbg !285, !tbaa !254
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep106 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !285
  %wide.load = load <16 x i8>* %13, align 1, !dbg !285, !tbaa !254
  %next.gep.sum282 = or i64 %index, 16, !dbg !285
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum282, !dbg !285
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !285
  %wide.load203 = load <16 x i8>* %15, align 1, !dbg !285, !tbaa !254
  %16 = bitcast i8* %next.gep106 to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !285, !tbaa !254
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum282, !dbg !285
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load203, <16 x i8>* %18, align 1, !dbg !285, !tbaa !254
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep106.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !285
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !285, !tbaa !254
  %next.gep.sum282.1 = or i64 %index.next, 16, !dbg !285
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum282.1, !dbg !285
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !285
  %wide.load203.1 = load <16 x i8>* %21, align 1, !dbg !285, !tbaa !254
  %22 = bitcast i8* %next.gep106.1 to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !285, !tbaa !254
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum282.1, !dbg !285
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !285
  store <16 x i8> %wide.load203.1, <16 x i8>* %24, align 1, !dbg !285, !tbaa !254
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !286

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
  %26 = add i64 %resume.val9, -1, !dbg !283
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !285
  %28 = load i8* %resume.val, align 1, !dbg !285, !tbaa !254
  %29 = getelementptr inbounds i8* %resume.val6, i64 1, !dbg !285
  store i8 %28, i8* %resume.val6, align 1, !dbg !285, !tbaa !254
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr, %unr.cmp305
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val9, %unr.cmp305 ]
  %30 = add i64 %.01.unr, -1, !dbg !283
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !285
  %32 = load i8* %src.03.unr, align 1, !dbg !285, !tbaa !254
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !285
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !285, !tbaa !254
  br label %.lr.ph.unr301

.lr.ph.unr301:                                    ; preds = %.lr.ph.unr300, %unr.cmp305
  %src.03.unr302 = phi i8* [ %31, %.lr.ph.unr300 ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr303 = phi i8* [ %33, %.lr.ph.unr300 ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr304 = phi i64 [ %30, %.lr.ph.unr300 ], [ %resume.val9, %unr.cmp305 ]
  %34 = add i64 %.01.unr304, -1, !dbg !283
  %35 = getelementptr inbounds i8* %src.03.unr302, i64 1, !dbg !285
  %36 = load i8* %src.03.unr302, align 1, !dbg !285, !tbaa !254
  %37 = getelementptr inbounds i8* %dest.02.unr303, i64 1, !dbg !285
  store i8 %36, i8* %dest.02.unr303, align 1, !dbg !285, !tbaa !254
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
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !285
  %40 = load i8* %src.03, align 1, !dbg !285, !tbaa !254
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !285
  store i8 %40, i8* %dest.02, align 1, !dbg !285, !tbaa !254
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !285
  %43 = load i8* %39, align 1, !dbg !285, !tbaa !254
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !285
  store i8 %43, i8* %41, align 1, !dbg !285, !tbaa !254
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !285
  %46 = load i8* %42, align 1, !dbg !285, !tbaa !254
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !285
  store i8 %46, i8* %44, align 1, !dbg !285, !tbaa !254
  %48 = add i64 %.01, -4, !dbg !283
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !285
  %50 = load i8* %45, align 1, !dbg !285, !tbaa !254
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !285
  store i8 %50, i8* %47, align 1, !dbg !285, !tbaa !254
  %52 = icmp eq i64 %48, 0, !dbg !283
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !283, !llvm.loop !287

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %53, !dbg !283

; <label>:53                                      ; preds = %._crit_edge, %0
  %dest.0.lcssa = phi i8* [ %scevgep, %._crit_edge ], [ %destaddr, %0 ]
  ret i8* %dest.0.lcssa, !dbg !288
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memset(i8* %dst, i32 %s, i64 %count) #4 {
  %1 = icmp eq i64 %count, 0, !dbg !289
  br i1 %1, label %._crit_edge, label %.lr.ph, !dbg !289

.lr.ph:                                           ; preds = %0
  %2 = trunc i32 %s to i8, !dbg !291
  %xtraiter = and i64 %count, 3
  switch i64 %xtraiter, label %3 [
    i64 0, label %.lr.ph.split
    i64 1, label %9
    i64 2, label %6
  ]

; <label>:3                                       ; preds = %.lr.ph
  %4 = add i64 %count, -1, !dbg !289
  %5 = getelementptr inbounds i8* %dst, i64 1, !dbg !291
  store volatile i8 %2, i8* %dst, align 1, !dbg !291, !tbaa !254
  br label %6

; <label>:6                                       ; preds = %3, %.lr.ph
  %a.02.unr = phi i8* [ %5, %3 ], [ %dst, %.lr.ph ]
  %.01.unr = phi i64 [ %4, %3 ], [ %count, %.lr.ph ]
  %7 = add i64 %.01.unr, -1, !dbg !289
  %8 = getelementptr inbounds i8* %a.02.unr, i64 1, !dbg !291
  store volatile i8 %2, i8* %a.02.unr, align 1, !dbg !291, !tbaa !254
  br label %9

; <label>:9                                       ; preds = %6, %.lr.ph
  %a.02.unr3 = phi i8* [ %8, %6 ], [ %dst, %.lr.ph ]
  %.01.unr4 = phi i64 [ %7, %6 ], [ %count, %.lr.ph ]
  %10 = add i64 %.01.unr4, -1, !dbg !289
  %11 = getelementptr inbounds i8* %a.02.unr3, i64 1, !dbg !291
  store volatile i8 %2, i8* %a.02.unr3, align 1, !dbg !291, !tbaa !254
  br label %.lr.ph.split

.lr.ph.split:                                     ; preds = %9, %.lr.ph
  %a.02.unr7 = phi i8* [ %dst, %.lr.ph ], [ %11, %9 ]
  %.01.unr8 = phi i64 [ %count, %.lr.ph ], [ %10, %9 ]
  %12 = icmp ult i64 %count, 4
  br i1 %12, label %._crit_edge, label %.lr.ph.split.split

.lr.ph.split.split:                               ; preds = %.lr.ph.split, %.lr.ph.split.split
  %a.02 = phi i8* [ %17, %.lr.ph.split.split ], [ %a.02.unr7, %.lr.ph.split ]
  %.01 = phi i64 [ %16, %.lr.ph.split.split ], [ %.01.unr8, %.lr.ph.split ]
  %13 = getelementptr inbounds i8* %a.02, i64 1, !dbg !291
  store volatile i8 %2, i8* %a.02, align 1, !dbg !291, !tbaa !254
  %14 = getelementptr inbounds i8* %a.02, i64 2, !dbg !291
  store volatile i8 %2, i8* %13, align 1, !dbg !291, !tbaa !254
  %15 = getelementptr inbounds i8* %a.02, i64 3, !dbg !291
  store volatile i8 %2, i8* %14, align 1, !dbg !291, !tbaa !254
  %16 = add i64 %.01, -4, !dbg !289
  %17 = getelementptr inbounds i8* %a.02, i64 4, !dbg !291
  store volatile i8 %2, i8* %15, align 1, !dbg !291, !tbaa !254
  %18 = icmp eq i64 %16, 0, !dbg !289
  br i1 %18, label %._crit_edge, label %.lr.ph.split.split, !dbg !289

._crit_edge:                                      ; preds = %.lr.ph.split.split, %.lr.ph.split, %0
  ret i8* %dst, !dbg !292
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

!llvm.dbg.cu = !{!0, !18, !29, !42, !54, !67, !87, !99, !111}
!llvm.module.flags = !{!126, !127}
!llvm.ident = !{!128, !128, !128, !128, !128, !128, !128, !128, !128}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metad
!1 = metadata !{metadata !"hash.c", metadata !"/playpen/ziqiao/2project/klee/analyzer/hash"}
!2 = metadata !{}
!3 = metadata !{metadata !4, metadata !11, metadata !14}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"int2bin", metadata !"int2bin", metadata !"", i32 6, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32, i8*, i32)* @int2bin, null, null, metadata !2, i32 6} ; [
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !10, metadata !8, metadata !10}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"hash", metadata !"hash", metadata !"", i32 21, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i8*, i8*, i8*, i32, i32)* @hash, null, null, metadata !2, i32 21
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{metadata !8, metadata !8, metadata !8, metadata !8, metadata !10, metadata !10}
!14 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 61, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 61} ; [ DW_TAG_s
!15 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !16, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!16 = metadata !{metadata !10, metadata !10, metadata !17}
!17 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!18 = metadata !{i32 786449, metadata !19, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !20, metadata !2, metadata !2, meta
!19 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!20 = metadata !{metadata !21}
!21 = metadata !{i32 786478, metadata !22, metadata !23, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"", i32 12, metadata !24, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* @klee_div_zero_check, null
!22 = metadata !{metadata !"klee_div_zero_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!23 = metadata !{i32 786473, metadata !22}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c]
!24 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !25, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!25 = metadata !{null, metadata !26}
!26 = metadata !{i32 786468, null, null, metadata !"long long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!27 = metadata !{metadata !28}
!28 = metadata !{i32 786689, metadata !21, metadata !"z", metadata !23, i32 16777228, metadata !26, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [z] [line 12]
!29 = metadata !{i32 786449, metadata !30, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !31, metadata !2, metadata !2, meta
!30 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_int.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!31 = metadata !{metadata !32}
!32 = metadata !{i32 786478, metadata !33, metadata !34, metadata !"klee_int", metadata !"klee_int", metadata !"", i32 13, metadata !35, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int, null, null, metadata !39, i32 13} ; [ 
!33 = metadata !{metadata !"klee_int.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!34 = metadata !{i32 786473, metadata !33}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_int.c]
!35 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !36, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!36 = metadata !{metadata !10, metadata !37}
!37 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !38} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!38 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!39 = metadata !{metadata !40, metadata !41}
!40 = metadata !{i32 786689, metadata !32, metadata !"name", metadata !34, i32 16777229, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!41 = metadata !{i32 786688, metadata !32, metadata !"x", metadata !34, i32 14, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!42 = metadata !{i32 786449, metadata !43, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !44, metadata !2, metadata !2, meta
!43 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!44 = metadata !{metadata !45}
!45 = metadata !{i32 786478, metadata !46, metadata !47, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"", i32 20, metadata !48, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64, i64)* @klee_overshift_che
!46 = metadata !{metadata !"klee_overshift_check.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!47 = metadata !{i32 786473, metadata !46}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!48 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !49, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!49 = metadata !{null, metadata !50, metadata !50}
!50 = metadata !{i32 786468, null, null, metadata !"long long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!51 = metadata !{metadata !52, metadata !53}
!52 = metadata !{i32 786689, metadata !45, metadata !"bitWidth", metadata !47, i32 16777236, metadata !50, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bitWidth] [line 20]
!53 = metadata !{i32 786689, metadata !45, metadata !"shift", metadata !47, i32 33554452, metadata !50, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [shift] [line 20]
!54 = metadata !{i32 786449, metadata !55, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !56, metadata !2, metadata !2, meta
!55 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!56 = metadata !{metadata !57}
!57 = metadata !{i32 786478, metadata !58, metadata !59, metadata !"klee_range", metadata !"klee_range", metadata !"", i32 13, metadata !60, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range, null, null, metadata !
!58 = metadata !{metadata !"klee_range.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!59 = metadata !{i32 786473, metadata !58}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!60 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !61, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!61 = metadata !{metadata !10, metadata !10, metadata !10, metadata !37}
!62 = metadata !{metadata !63, metadata !64, metadata !65, metadata !66}
!63 = metadata !{i32 786689, metadata !57, metadata !"start", metadata !59, i32 16777229, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [start] [line 13]
!64 = metadata !{i32 786689, metadata !57, metadata !"end", metadata !59, i32 33554445, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [end] [line 13]
!65 = metadata !{i32 786689, metadata !57, metadata !"name", metadata !59, i32 50331661, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [name] [line 13]
!66 = metadata !{i32 786688, metadata !57, metadata !"x", metadata !59, i32 14, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 14]
!67 = metadata !{i32 786449, metadata !68, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !69, metadata !2, metadata !2, meta
!68 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!69 = metadata !{metadata !70}
!70 = metadata !{i32 786478, metadata !71, metadata !72, metadata !"memcpy", metadata !"memcpy", metadata !"", i32 12, metadata !73, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memcpy, null, null, metadata !81, i32 12} 
!71 = metadata !{metadata !"memcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!72 = metadata !{i32 786473, metadata !71}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c]
!73 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !74, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!74 = metadata !{metadata !75, metadata !75, metadata !76, metadata !78}
!75 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!76 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !77} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!77 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from ]
!78 = metadata !{i32 786454, metadata !79, null, metadata !"size_t", i32 58, i64 0, i64 0, i64 0, i32 0, metadata !80} ; [ DW_TAG_typedef ] [size_t] [line 58, size 0, align 0, offset 0] [from long unsigned int]
!79 = metadata !{metadata !"/usr/lib/llvm-3.5/bin/../lib/clang/3.5.0/include/stddef.h", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!80 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!81 = metadata !{metadata !82, metadata !83, metadata !84, metadata !85, metadata !86}
!82 = metadata !{i32 786689, metadata !70, metadata !"destaddr", metadata !72, i32 16777228, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 12]
!83 = metadata !{i32 786689, metadata !70, metadata !"srcaddr", metadata !72, i32 33554444, metadata !76, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 12]
!84 = metadata !{i32 786689, metadata !70, metadata !"len", metadata !72, i32 50331660, metadata !78, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 12]
!85 = metadata !{i32 786688, metadata !70, metadata !"dest", metadata !72, i32 13, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 13]
!86 = metadata !{i32 786688, metadata !70, metadata !"src", metadata !72, i32 14, metadata !37, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 14]
!87 = metadata !{i32 786449, metadata !88, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !89, metadata !2, metadata !2, meta
!88 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!89 = metadata !{metadata !90}
!90 = metadata !{i32 786478, metadata !91, metadata !92, metadata !"memmove", metadata !"memmove", metadata !"", i32 12, metadata !73, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @memmove, null, null, metadata !93, i32 1
!91 = metadata !{metadata !"memmove.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!92 = metadata !{i32 786473, metadata !91}        ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!93 = metadata !{metadata !94, metadata !95, metadata !96, metadata !97, metadata !98}
!94 = metadata !{i32 786689, metadata !90, metadata !"dst", metadata !92, i32 16777228, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 12]
!95 = metadata !{i32 786689, metadata !90, metadata !"src", metadata !92, i32 33554444, metadata !76, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [src] [line 12]
!96 = metadata !{i32 786689, metadata !90, metadata !"count", metadata !92, i32 50331660, metadata !78, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 12]
!97 = metadata !{i32 786688, metadata !90, metadata !"a", metadata !92, i32 13, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 13]
!98 = metadata !{i32 786688, metadata !90, metadata !"b", metadata !92, i32 14, metadata !37, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [b] [line 14]
!99 = metadata !{i32 786449, metadata !100, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !101, metadata !2, metadata !2, me
!100 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!101 = metadata !{metadata !102}
!102 = metadata !{i32 786478, metadata !103, metadata !104, metadata !"mempcpy", metadata !"mempcpy", metadata !"", i32 11, metadata !73, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy, null, null, metadata !105, i
!103 = metadata !{metadata !"mempcpy.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!104 = metadata !{i32 786473, metadata !103}      ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c]
!105 = metadata !{metadata !106, metadata !107, metadata !108, metadata !109, metadata !110}
!106 = metadata !{i32 786689, metadata !102, metadata !"destaddr", metadata !104, i32 16777227, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [destaddr] [line 11]
!107 = metadata !{i32 786689, metadata !102, metadata !"srcaddr", metadata !104, i32 33554443, metadata !76, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [srcaddr] [line 11]
!108 = metadata !{i32 786689, metadata !102, metadata !"len", metadata !104, i32 50331659, metadata !78, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [len] [line 11]
!109 = metadata !{i32 786688, metadata !102, metadata !"dest", metadata !104, i32 12, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [dest] [line 12]
!110 = metadata !{i32 786688, metadata !102, metadata !"src", metadata !104, i32 13, metadata !37, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [src] [line 13]
!111 = metadata !{i32 786449, metadata !112, i32 1, metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)", i1 true, metadata !"", i32 0, metadata !2, metadata !2, metadata !113, metadata !2, metadata !2, m
!112 = metadata !{metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!113 = metadata !{metadata !114}
!114 = metadata !{i32 786478, metadata !115, metadata !116, metadata !"memset", metadata !"memset", metadata !"", i32 11, metadata !117, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i32, i64)* @memset, null, null, metadata !119, i32
!115 = metadata !{metadata !"memset.c", metadata !"/playpen/ziqiao/2project/klee/runtime/Intrinsic"}
!116 = metadata !{i32 786473, metadata !115}      ; [ DW_TAG_file_type ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c]
!117 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !118, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!118 = metadata !{metadata !75, metadata !75, metadata !10, metadata !78}
!119 = metadata !{metadata !120, metadata !121, metadata !122, metadata !123}
!120 = metadata !{i32 786689, metadata !114, metadata !"dst", metadata !116, i32 16777227, metadata !75, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [dst] [line 11]
!121 = metadata !{i32 786689, metadata !114, metadata !"s", metadata !116, i32 33554443, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [s] [line 11]
!122 = metadata !{i32 786689, metadata !114, metadata !"count", metadata !116, i32 50331659, metadata !78, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [count] [line 11]
!123 = metadata !{i32 786688, metadata !114, metadata !"a", metadata !116, i32 12, metadata !124, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 12]
!124 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !125} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!125 = metadata !{i32 786485, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_volatile_type ] [line 0, size 0, align 0, offset 0] [from char]
!126 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!127 = metadata !{i32 2, metadata !"Debug Info Version", i32 1}
!128 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
!129 = metadata !{i32 7, i32 6, metadata !4, null}
!130 = metadata !{i32 8, i32 4, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!131 = metadata !{i32 10, i32 12, metadata !132, null}
!132 = metadata !{i32 786443, metadata !1, metadata !4, i32 10, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!133 = metadata !{i32 10, i32 12, metadata !134, null}
!134 = metadata !{i32 786443, metadata !1, metadata !135, i32 10, i32 12, i32 2, i32 16} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!135 = metadata !{i32 786443, metadata !1, metadata !132, i32 10, i32 12, i32 1, i32 15} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!136 = metadata !{i32 11, i32 13, metadata !137, null}
!137 = metadata !{i32 786443, metadata !1, metadata !132, i32 10, i32 37, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!138 = metadata !{i32 13, i32 15, metadata !137, null}
!139 = metadata !{i32 10, i32 32, metadata !132, null}
!140 = metadata !{i32 16, i32 8, metadata !4, null}
!141 = metadata !{i32 22, i32 2, metadata !11, null}
!142 = metadata !{i32 23, i32 2, metadata !11, null}
!143 = metadata !{i32 24, i32 2, metadata !11, null}
!144 = metadata !{i32 25, i32 6, metadata !145, null}
!145 = metadata !{i32 786443, metadata !1, metadata !11, i32 25, i32 6, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!146 = metadata !{i32 25, i32 6, metadata !147, null}
!147 = metadata !{i32 786443, metadata !1, metadata !145, i32 25, i32 6, i32 2, i32 18} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!148 = metadata !{i32 25, i32 30, metadata !149, null}
!149 = metadata !{i32 786443, metadata !1, metadata !150, i32 25, i32 30, i32 3, i32 19} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!150 = metadata !{i32 786443, metadata !1, metadata !145, i32 25, i32 30, i32 1, i32 17} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!151 = metadata !{i32 30, i32 6, metadata !11, null}
!152 = metadata !{i32 31, i32 2, metadata !11, null}
!153 = metadata !{i32 32, i32 8, metadata !154, null}
!154 = metadata !{i32 786443, metadata !1, metadata !11, i32 32, i32 3, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!155 = metadata !{i32 32, i32 8, metadata !156, null}
!156 = metadata !{i32 786443, metadata !1, metadata !157, i32 32, i32 8, i32 2, i32 27} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!157 = metadata !{i32 786443, metadata !1, metadata !154, i32 32, i32 8, i32 1, i32 20} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!158 = metadata !{i32 33, i32 3, metadata !159, null}
!159 = metadata !{i32 786443, metadata !1, metadata !154, i32 32, i32 20, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!160 = metadata !{i32 34, i32 7, metadata !161, null}
!161 = metadata !{i32 786443, metadata !1, metadata !159, i32 34, i32 3, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!162 = metadata !{i32 34, i32 7, metadata !163, null}
!163 = metadata !{i32 786443, metadata !1, metadata !164, i32 34, i32 7, i32 2, i32 26} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!164 = metadata !{i32 786443, metadata !1, metadata !161, i32 34, i32 7, i32 1, i32 21} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!165 = metadata !{i32 35, i32 4, metadata !166, null}
!166 = metadata !{i32 786443, metadata !1, metadata !161, i32 34, i32 26, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!167 = metadata !{i32 36, i32 8, metadata !168, null}
!168 = metadata !{i32 786443, metadata !1, metadata !166, i32 36, i32 4, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!169 = metadata !{i32 36, i32 8, metadata !170, null}
!170 = metadata !{i32 786443, metadata !1, metadata !171, i32 36, i32 8, i32 2, i32 25} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!171 = metadata !{i32 786443, metadata !1, metadata !168, i32 36, i32 8, i32 1, i32 22} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!172 = metadata !{i32 37, i32 5, metadata !173, null}
!173 = metadata !{i32 786443, metadata !1, metadata !168, i32 36, i32 20, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!174 = metadata !{i32 38, i32 5, metadata !173, null}
!175 = metadata !{i32 39, i32 5, metadata !173, null}
!176 = metadata !{i32 40, i32 5, metadata !173, null}
!177 = metadata !{i32 41, i32 5, metadata !173, null}
!178 = metadata !{i32 42, i32 5, metadata !173, null}
!179 = metadata !{i32 43, i32 5, metadata !173, null}
!180 = metadata !{i32 44, i32 5, metadata !173, null}
!181 = metadata !{i32 45, i32 5, metadata !173, null}
!182 = metadata !{i32 46, i32 9, metadata !183, null}
!183 = metadata !{i32 786443, metadata !1, metadata !173, i32 46, i32 5, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!184 = metadata !{i32 46, i32 9, metadata !185, null}
!185 = metadata !{i32 786443, metadata !1, metadata !186, i32 46, i32 9, i32 2, i32 24} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!186 = metadata !{i32 786443, metadata !1, metadata !183, i32 46, i32 9, i32 1, i32 23} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!187 = metadata !{i32 47, i32 6, metadata !188, null}
!188 = metadata !{i32 786443, metadata !1, metadata !183, i32 46, i32 28, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!189 = metadata !{i32 49, i32 6, metadata !188, null}
!190 = metadata !{i32 46, i32 24, metadata !183, null}
!191 = metadata !{i32 36, i32 16, metadata !168, null}
!192 = metadata !{i32 53, i32 4, metadata !166, null}
!193 = metadata !{i32 54, i32 4, metadata !166, null}
!194 = metadata !{i32 55, i32 4, metadata !166, null}
!195 = metadata !{i32 34, i32 22, metadata !161, null}
!196 = metadata !{i32 32, i32 16, metadata !154, null}
!197 = metadata !{i32 59, i32 1, metadata !11, null}
!198 = metadata !{i32 62, i32 2, metadata !14, null}
!199 = metadata !{i32 64, i32 2, metadata !14, null}
!200 = metadata !{i32 66, i32 2, metadata !14, null}
!201 = metadata !{i32 68, i32 7, metadata !202, null}
!202 = metadata !{i32 786443, metadata !1, metadata !14, i32 68, i32 2, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!203 = metadata !{i32 68, i32 7, metadata !204, null}
!204 = metadata !{i32 786443, metadata !1, metadata !205, i32 68, i32 7, i32 2, i32 29} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!205 = metadata !{i32 786443, metadata !1, metadata !202, i32 68, i32 7, i32 1, i32 28} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!206 = metadata !{i32 69, i32 3, metadata !207, null}
!207 = metadata !{i32 786443, metadata !1, metadata !202, i32 68, i32 20, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!208 = metadata !{i32 68, i32 16, metadata !202, null}
!209 = metadata !{i32 75, i32 3, metadata !14, null}
!210 = metadata !{i32 76, i32 2, metadata !14, null}
!211 = metadata !{i32 77, i32 5, metadata !212, null}
!212 = metadata !{i32 786443, metadata !1, metadata !14, i32 77, i32 5, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!213 = metadata !{i32 78, i32 3, metadata !214, null}
!214 = metadata !{i32 786443, metadata !1, metadata !212, i32 77, i32 18, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!215 = metadata !{i32 79, i32 3, metadata !214, null}
!216 = metadata !{i32 81, i32 2, metadata !14, null}
!217 = metadata !{i32 84, i32 2, metadata !14, null}
!218 = metadata !{i32 86, i32 1, metadata !14, null}
!219 = metadata !{i32 13, i32 7, metadata !220, null}
!220 = metadata !{i32 786443, metadata !22, metadata !21, i32 13, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c]
!221 = metadata !{i32 14, i32 5, metadata !220, null}
!222 = metadata !{i32 15, i32 1, metadata !21, null}
!223 = metadata !{i32 15, i32 3, metadata !32, null}
!224 = metadata !{i32 16, i32 3, metadata !32, null}
!225 = metadata !{metadata !226, metadata !226, i64 0}
!226 = metadata !{metadata !"int", metadata !227, i64 0}
!227 = metadata !{metadata !"omnipotent char", metadata !228, i64 0}
!228 = metadata !{metadata !"Simple C/C++ TBAA"}
!229 = metadata !{i32 21, i32 7, metadata !230, null}
!230 = metadata !{i32 786443, metadata !46, metadata !45, i32 21, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!231 = metadata !{i32 27, i32 5, metadata !232, null}
!232 = metadata !{i32 786443, metadata !46, metadata !230, i32 21, i32 26, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!233 = metadata !{i32 29, i32 1, metadata !45, null}
!234 = metadata !{i32 16, i32 7, metadata !235, null}
!235 = metadata !{i32 786443, metadata !58, metadata !57, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!236 = metadata !{i32 17, i32 5, metadata !235, null}
!237 = metadata !{i32 19, i32 7, metadata !238, null}
!238 = metadata !{i32 786443, metadata !58, metadata !57, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!239 = metadata !{i32 22, i32 5, metadata !240, null}
!240 = metadata !{i32 786443, metadata !58, metadata !238, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!241 = metadata !{i32 25, i32 9, metadata !242, null}
!242 = metadata !{i32 786443, metadata !58, metadata !240, i32 25, i32 9, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!243 = metadata !{i32 26, i32 7, metadata !244, null}
!244 = metadata !{i32 786443, metadata !58, metadata !242, i32 25, i32 19, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!245 = metadata !{i32 27, i32 5, metadata !244, null}
!246 = metadata !{i32 28, i32 7, metadata !247, null}
!247 = metadata !{i32 786443, metadata !58, metadata !242, i32 27, i32 12, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!248 = metadata !{i32 29, i32 7, metadata !247, null}
!249 = metadata !{i32 32, i32 5, metadata !240, null}
!250 = metadata !{i32 34, i32 1, metadata !57, null}
!251 = metadata !{i32 16, i32 3, metadata !252, null}
!252 = metadata !{i32 786443, metadata !71, metadata !70, i32 16, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c]
!253 = metadata !{i32 17, i32 5, metadata !70, null}
!254 = metadata !{metadata !227, metadata !227, i64 0}
!255 = metadata !{metadata !255, metadata !256, metadata !257}
!256 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!257 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!258 = metadata !{metadata !258, metadata !256, metadata !257}
!259 = metadata !{i32 18, i32 3, metadata !70, null}
!260 = metadata !{i32 16, i32 7, metadata !261, null}
!261 = metadata !{i32 786443, metadata !91, metadata !90, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!262 = metadata !{i32 19, i32 7, metadata !263, null}
!263 = metadata !{i32 786443, metadata !91, metadata !90, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!264 = metadata !{i32 20, i32 5, metadata !265, null}
!265 = metadata !{i32 786443, metadata !91, metadata !266, i32 20, i32 5, i32 3, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!266 = metadata !{i32 786443, metadata !91, metadata !267, i32 20, i32 5, i32 1, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!267 = metadata !{i32 786443, metadata !91, metadata !263, i32 19, i32 16, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!268 = metadata !{i32 20, i32 21, metadata !269, null}
!269 = metadata !{i32 786443, metadata !91, metadata !267, i32 20, i32 21, i32 2, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!270 = metadata !{metadata !270, metadata !256, metadata !257}
!271 = metadata !{metadata !271, metadata !256, metadata !257}
!272 = metadata !{i32 22, i32 5, metadata !273, null}
!273 = metadata !{i32 786443, metadata !91, metadata !263, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!274 = metadata !{i32 24, i32 5, metadata !275, null}
!275 = metadata !{i32 786443, metadata !91, metadata !276, i32 24, i32 5, i32 3, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!276 = metadata !{i32 786443, metadata !91, metadata !273, i32 24, i32 5, i32 1, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!277 = metadata !{i32 23, i32 5, metadata !273, null}
!278 = metadata !{i32 24, i32 21, metadata !279, null}
!279 = metadata !{i32 786443, metadata !91, metadata !273, i32 24, i32 21, i32 2, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!280 = metadata !{metadata !280, metadata !256, metadata !257}
!281 = metadata !{metadata !281, metadata !256, metadata !257}
!282 = metadata !{i32 28, i32 1, metadata !90, null}
!283 = metadata !{i32 15, i32 3, metadata !284, null}
!284 = metadata !{i32 786443, metadata !103, metadata !102, i32 15, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c]
!285 = metadata !{i32 16, i32 5, metadata !102, null}
!286 = metadata !{metadata !286, metadata !256, metadata !257}
!287 = metadata !{metadata !287, metadata !256, metadata !257}
!288 = metadata !{i32 17, i32 3, metadata !102, null}
!289 = metadata !{i32 13, i32 5, metadata !290, null}
!290 = metadata !{i32 786443, metadata !115, metadata !114, i32 13, i32 5, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c]
!291 = metadata !{i32 14, i32 7, metadata !114, null}
!292 = metadata !{i32 15, i32 5, metadata !114, null}
