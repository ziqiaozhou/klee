; ModuleID = 'hash.bc'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"%d,%d,%d,%s & \00", align 1
@.str1 = private unnamed_addr constant [5 x i8] c"%s =\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"xor=%d,\00", align 1
@.str4 = private unnamed_addr constant [13 x i8] c"result_i=%d\0A\00", align 1
@.str5 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@.str6 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str7 = private unnamed_addr constant [4 x i8] c"%lx\00", align 1
@.str8 = private unnamed_addr constant [13 x i8] c"result alert\00", align 1
@.str9 = private unnamed_addr constant [17 x i8] c"result not alert\00", align 1
@.str10 = private unnamed_addr constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str111 = private unnamed_addr constant [15 x i8] c"divide by zero\00", align 1
@.str212 = private unnamed_addr constant [8 x i8] c"div.err\00", align 1
@.str313 = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str25 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1
@.str614 = private unnamed_addr constant [13 x i8] c"klee_range.c\00", align 1
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
  %base = alloca i32, align 4
  %max = alloca i32, align 4
  %y = alloca i8, align 1
  %a = alloca i8, align 1
  %result_i_ptr1 = alloca i8*, align 8
  %y2 = alloca i8, align 1
  %a3 = alloca i8, align 1
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
  br label %234, !dbg !148

; <label>:15                                      ; preds = %0
  %16 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i64 32, !dbg !151
  store i8 0, i8* %16, align 1, !dbg !151
  store i32 0, i32* %i, align 4, !dbg !152
  br label %17, !dbg !152

; <label>:17                                      ; preds = %130, %15
  %18 = load i32* %i, align 4, !dbg !154
  %19 = load i32* %6, align 4, !dbg !154
  %int_cast_to_i64 = zext i32 8 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i64), !dbg !154
  %20 = sdiv i32 %19, 8, !dbg !154
  %21 = icmp slt i32 %18, %20, !dbg !154
  %22 = load i32* %i, align 4, !dbg !157
  %23 = sext i32 %22 to i64, !dbg !157
  %24 = load i8** %result, align 8, !dbg !157
  %25 = getelementptr inbounds i8* %24, i64 %23, !dbg !157
  br i1 %21, label %26, label %133, !dbg !154

; <label>:26                                      ; preds = %17
  store i8* %25, i8** %result_i_ptr, align 8, !dbg !157
  %27 = load i8** %result_i_ptr, align 8, !dbg !159
  %28 = call i8* @memset(i8* %27, i32 0, i64 1)
  %29 = load i32* %i, align 4, !dbg !160
  %30 = mul nsw i32 %29, 8, !dbg !160
  store i32 %30, i32* %base, align 4, !dbg !160
  %31 = load i32* %i, align 4, !dbg !160
  %32 = add nsw i32 %31, 1, !dbg !160
  %33 = mul nsw i32 %32, 8, !dbg !160
  store i32 %33, i32* %max, align 4, !dbg !160
  store i32 0, i32* %k, align 4, !dbg !161
  br label %34, !dbg !161

; <label>:34                                      ; preds = %112, %26
  %35 = load i32* %k, align 4, !dbg !163
  %36 = icmp slt i32 %35, 8, !dbg !163
  br i1 %36, label %37, label %130, !dbg !163

; <label>:37                                      ; preds = %34
  %38 = load i8** %data, align 8, !dbg !166
  %39 = getelementptr inbounds i8* %38, i64 0, !dbg !166
  %40 = load i8* %39, align 1, !dbg !166
  %41 = zext i8 %40 to i32, !dbg !166
  %42 = and i32 1, %41, !dbg !166
  %43 = trunc i32 %42 to i8, !dbg !166
  store i8 %43, i8* %axory, align 1, !dbg !166
  store i32 0, i32* %l, align 4, !dbg !168
  br label %44, !dbg !168

; <label>:44                                      ; preds = %109, %37
  %45 = load i32* %l, align 4, !dbg !170
  %46 = load i32* %5, align 4, !dbg !170
  %47 = icmp slt i32 %45, %46, !dbg !170
  br i1 %47, label %48, label %112, !dbg !170

; <label>:48                                      ; preds = %44
  %49 = load i32* %l, align 4, !dbg !173
  %50 = sext i32 %49 to i64, !dbg !173
  %51 = load i8** %data, align 8, !dbg !173
  %52 = getelementptr inbounds i8* %51, i64 %50, !dbg !173
  %53 = load i8* %52, align 1, !dbg !173
  store i8 %53, i8* %y, align 1, !dbg !173
  %54 = load i32* %k, align 4, !dbg !175
  %55 = load i32* %i, align 4, !dbg !175
  %56 = mul nsw i32 8, %55, !dbg !175
  %57 = add nsw i32 %54, %56, !dbg !175
  %58 = mul nsw i32 %57, 4, !dbg !175
  %59 = load i32* %l, align 4, !dbg !175
  %60 = add nsw i32 %58, %59, !dbg !175
  %61 = sext i32 %60 to i64, !dbg !175
  %62 = load i8** %key, align 8, !dbg !175
  %63 = getelementptr inbounds i8* %62, i64 %61, !dbg !175
  %64 = load i8* %63, align 1, !dbg !175
  store i8 %64, i8* %a, align 1, !dbg !175
  %65 = load i8* %a, align 1, !dbg !176
  %66 = zext i8 %65 to i32, !dbg !176
  %67 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !176
  %68 = call i8* @int2bin(i32 %66, i8* %67, i32 32), !dbg !176
  %69 = load i32* %i, align 4, !dbg !177
  %70 = load i32* %k, align 4, !dbg !177
  %71 = load i32* %l, align 4, !dbg !177
  %72 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !177
  %73 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([15 x i8]* @.str, i32 0, i32 0), i32 %69, i32 %70, i32 %71, i8* %72), !dbg !177
  %74 = load i8* %y, align 1, !dbg !178
  %75 = zext i8 %74 to i32, !dbg !178
  %76 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !178
  %77 = call i8* @int2bin(i32 %75, i8* %76, i32 32), !dbg !178
  %78 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !179
  %79 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str1, i32 0, i32 0), i8* %78), !dbg !179
  %80 = load i8* %a, align 1, !dbg !180
  %81 = zext i8 %80 to i32, !dbg !180
  %82 = load i8* %y, align 1, !dbg !180
  %83 = zext i8 %82 to i32, !dbg !180
  %84 = and i32 %81, %83, !dbg !180
  %85 = trunc i32 %84 to i8, !dbg !180
  store i8 %85, i8* %aAndy, align 1, !dbg !180
  %86 = load i8* %aAndy, align 1, !dbg !181
  %87 = zext i8 %86 to i32, !dbg !181
  %88 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !181
  %89 = call i8* @int2bin(i32 %87, i8* %88, i32 32), !dbg !181
  %90 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !182
  %91 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i8* %90), !dbg !182
  store i32 0, i32* %j, align 4, !dbg !183
  br label %92, !dbg !183

; <label>:92                                      ; preds = %95, %48
  %93 = load i32* %j, align 4, !dbg !185
  %94 = icmp slt i32 %93, 8, !dbg !185
  br i1 %94, label %95, label %109, !dbg !185

; <label>:95                                      ; preds = %92
  %96 = load i8* %aAndy, align 1, !dbg !188
  %97 = zext i8 %96 to i32, !dbg !188
  %98 = and i32 %97, 1, !dbg !188
  %99 = load i8* %axory, align 1, !dbg !188
  %100 = zext i8 %99 to i32, !dbg !188
  %101 = xor i32 %100, %98, !dbg !188
  %102 = trunc i32 %101 to i8, !dbg !188
  store i8 %102, i8* %axory, align 1, !dbg !188
  %103 = load i8* %aAndy, align 1, !dbg !190
  %104 = zext i8 %103 to i32, !dbg !190
  %int_cast_to_i642 = zext i32 1 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i642), !dbg !190
  %105 = ashr i32 %104, 1, !dbg !190
  %106 = trunc i32 %105 to i8, !dbg !190
  store i8 %106, i8* %aAndy, align 1, !dbg !190
  %107 = load i32* %j, align 4, !dbg !191
  %108 = add nsw i32 %107, 1, !dbg !191
  store i32 %108, i32* %j, align 4, !dbg !191
  br label %92, !dbg !191

; <label>:109                                     ; preds = %92
  %110 = load i32* %l, align 4, !dbg !192
  %111 = add nsw i32 %110, 1, !dbg !192
  store i32 %111, i32* %l, align 4, !dbg !192
  br label %44, !dbg !192

; <label>:112                                     ; preds = %44
  %113 = load i8* %axory, align 1, !dbg !193
  %114 = zext i8 %113 to i32, !dbg !193
  %115 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str3, i32 0, i32 0), i32 %114), !dbg !193
  %116 = load i8* %axory, align 1, !dbg !194
  %117 = zext i8 %116 to i32, !dbg !194
  %118 = load i32* %k, align 4, !dbg !194
  %int_cast_to_i643 = zext i32 %118 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i643), !dbg !194
  %119 = shl i32 %117, %118, !dbg !194
  %120 = load i8** %result_i_ptr, align 8, !dbg !194
  %121 = load i8* %120, align 1, !dbg !194
  %122 = zext i8 %121 to i32, !dbg !194
  %123 = or i32 %122, %119, !dbg !194
  %124 = trunc i32 %123 to i8, !dbg !194
  store i8 %124, i8* %120, align 1, !dbg !194
  %125 = load i8* %axory, align 1, !dbg !195
  %126 = zext i8 %125 to i32, !dbg !195
  %127 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str4, i32 0, i32 0), i32 %126), !dbg !195
  %128 = load i32* %k, align 4, !dbg !196
  %129 = add nsw i32 %128, 1, !dbg !196
  store i32 %129, i32* %k, align 4, !dbg !196
  br label %34, !dbg !196

; <label>:130                                     ; preds = %34
  %131 = load i32* %i, align 4, !dbg !197
  %132 = add nsw i32 %131, 1, !dbg !197
  store i32 %132, i32* %i, align 4, !dbg !197
  br label %17, !dbg !197

; <label>:133                                     ; preds = %17
  store i8* %25, i8** %result_i_ptr1, align 8, !dbg !198
  %134 = load i8** %result_i_ptr1, align 8, !dbg !199
  %135 = call i8* @memset(i8* %134, i32 0, i64 1)
  store i32 0, i32* %k, align 4, !dbg !200
  br label %136, !dbg !200

; <label>:136                                     ; preds = %216, %133
  %137 = load i32* %k, align 4, !dbg !202
  %138 = load i32* %6, align 4, !dbg !202
  %int_cast_to_i641 = zext i32 8 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i641), !dbg !202
  %139 = srem i32 %138, 8, !dbg !202
  %140 = icmp slt i32 %137, %139, !dbg !202
  br i1 %140, label %141, label %234, !dbg !202

; <label>:141                                     ; preds = %136
  %142 = load i8** %data, align 8, !dbg !205
  %143 = getelementptr inbounds i8* %142, i64 0, !dbg !205
  %144 = load i8* %143, align 1, !dbg !205
  %145 = zext i8 %144 to i32, !dbg !205
  %146 = and i32 1, %145, !dbg !205
  %147 = trunc i32 %146 to i8, !dbg !205
  store i8 %147, i8* %axory, align 1, !dbg !205
  store i32 0, i32* %l, align 4, !dbg !207
  br label %148, !dbg !207

; <label>:148                                     ; preds = %213, %141
  %149 = load i32* %l, align 4, !dbg !209
  %150 = load i32* %5, align 4, !dbg !209
  %151 = icmp slt i32 %149, %150, !dbg !209
  br i1 %151, label %152, label %216, !dbg !209

; <label>:152                                     ; preds = %148
  %153 = load i32* %l, align 4, !dbg !212
  %154 = sext i32 %153 to i64, !dbg !212
  %155 = load i8** %data, align 8, !dbg !212
  %156 = getelementptr inbounds i8* %155, i64 %154, !dbg !212
  %157 = load i8* %156, align 1, !dbg !212
  store i8 %157, i8* %y2, align 1, !dbg !212
  %158 = load i32* %k, align 4, !dbg !214
  %159 = load i32* %i, align 4, !dbg !214
  %160 = mul nsw i32 8, %159, !dbg !214
  %161 = add nsw i32 %158, %160, !dbg !214
  %162 = mul nsw i32 %161, 4, !dbg !214
  %163 = load i32* %l, align 4, !dbg !214
  %164 = add nsw i32 %162, %163, !dbg !214
  %165 = sext i32 %164 to i64, !dbg !214
  %166 = load i8** %key, align 8, !dbg !214
  %167 = getelementptr inbounds i8* %166, i64 %165, !dbg !214
  %168 = load i8* %167, align 1, !dbg !214
  store i8 %168, i8* %a3, align 1, !dbg !214
  %169 = load i8* %a3, align 1, !dbg !215
  %170 = zext i8 %169 to i32, !dbg !215
  %171 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !215
  %172 = call i8* @int2bin(i32 %170, i8* %171, i32 32), !dbg !215
  %173 = load i32* %i, align 4, !dbg !216
  %174 = load i32* %k, align 4, !dbg !216
  %175 = load i32* %l, align 4, !dbg !216
  %176 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !216
  %177 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([15 x i8]* @.str, i32 0, i32 0), i32 %173, i32 %174, i32 %175, i8* %176), !dbg !216
  %178 = load i8* %y2, align 1, !dbg !217
  %179 = zext i8 %178 to i32, !dbg !217
  %180 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !217
  %181 = call i8* @int2bin(i32 %179, i8* %180, i32 32), !dbg !217
  %182 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !218
  %183 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str1, i32 0, i32 0), i8* %182), !dbg !218
  %184 = load i8* %a3, align 1, !dbg !219
  %185 = zext i8 %184 to i32, !dbg !219
  %186 = load i8* %y2, align 1, !dbg !219
  %187 = zext i8 %186 to i32, !dbg !219
  %188 = and i32 %185, %187, !dbg !219
  %189 = trunc i32 %188 to i8, !dbg !219
  store i8 %189, i8* %aAndy, align 1, !dbg !219
  %190 = load i8* %aAndy, align 1, !dbg !220
  %191 = zext i8 %190 to i32, !dbg !220
  %192 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !220
  %193 = call i8* @int2bin(i32 %191, i8* %192, i32 32), !dbg !220
  %194 = getelementptr inbounds [33 x i8]* %buffer, i32 0, i32 0, !dbg !221
  %195 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i8* %194), !dbg !221
  store i32 0, i32* %j, align 4, !dbg !222
  br label %196, !dbg !222

; <label>:196                                     ; preds = %199, %152
  %197 = load i32* %j, align 4, !dbg !224
  %198 = icmp slt i32 %197, 8, !dbg !224
  br i1 %198, label %199, label %213, !dbg !224

; <label>:199                                     ; preds = %196
  %200 = load i8* %aAndy, align 1, !dbg !227
  %201 = zext i8 %200 to i32, !dbg !227
  %202 = and i32 %201, 1, !dbg !227
  %203 = load i8* %axory, align 1, !dbg !227
  %204 = zext i8 %203 to i32, !dbg !227
  %205 = xor i32 %204, %202, !dbg !227
  %206 = trunc i32 %205 to i8, !dbg !227
  store i8 %206, i8* %axory, align 1, !dbg !227
  %207 = load i8* %aAndy, align 1, !dbg !229
  %208 = zext i8 %207 to i32, !dbg !229
  %int_cast_to_i644 = zext i32 1 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i644), !dbg !229
  %209 = ashr i32 %208, 1, !dbg !229
  %210 = trunc i32 %209 to i8, !dbg !229
  store i8 %210, i8* %aAndy, align 1, !dbg !229
  %211 = load i32* %j, align 4, !dbg !230
  %212 = add nsw i32 %211, 1, !dbg !230
  store i32 %212, i32* %j, align 4, !dbg !230
  br label %196, !dbg !230

; <label>:213                                     ; preds = %196
  %214 = load i32* %l, align 4, !dbg !231
  %215 = add nsw i32 %214, 1, !dbg !231
  store i32 %215, i32* %l, align 4, !dbg !231
  br label %148, !dbg !231

; <label>:216                                     ; preds = %148
  %217 = load i8* %axory, align 1, !dbg !232
  %218 = zext i8 %217 to i32, !dbg !232
  %219 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str3, i32 0, i32 0), i32 %218), !dbg !232
  %220 = load i8* %axory, align 1, !dbg !233
  %221 = zext i8 %220 to i32, !dbg !233
  %222 = load i32* %k, align 4, !dbg !233
  %int_cast_to_i645 = zext i32 %222 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i645), !dbg !233
  %223 = shl i32 %221, %222, !dbg !233
  %224 = load i8** %result_i_ptr1, align 8, !dbg !233
  %225 = load i8* %224, align 1, !dbg !233
  %226 = zext i8 %225 to i32, !dbg !233
  %227 = or i32 %226, %223, !dbg !233
  %228 = trunc i32 %227 to i8, !dbg !233
  store i8 %228, i8* %224, align 1, !dbg !233
  %229 = load i8* %axory, align 1, !dbg !234
  %230 = zext i8 %229 to i32, !dbg !234
  %231 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str4, i32 0, i32 0), i32 %230), !dbg !234
  %232 = load i32* %k, align 4, !dbg !235
  %233 = add nsw i32 %232, 1, !dbg !235
  store i32 %233, i32* %k, align 4, !dbg !235
  br label %136, !dbg !235

; <label>:234                                     ; preds = %136, %14
  %235 = load i8** %1, !dbg !236
  ret i8* %235, !dbg !236
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
  %len = alloca i32, align 4
  %keyb = alloca i8*, align 8
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  %data = alloca [4 x i8], align 1
  %result = alloca i32, align 4
  %idata = alloca i32, align 4
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 4, i32* %n, align 4, !dbg !237
  store i32 3, i32* %m, align 4, !dbg !237
  store i32 96, i32* %len, align 4, !dbg !238
  %4 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !239
  store i8* %4, i8** %keyb, align 8, !dbg !239
  store i32 715826517, i32* %x, align 4, !dbg !240
  %5 = call i32 (i32*, i64, i32, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i32*, i64, i32, ...)*)(i32* %m, i64 4, i32 109), !dbg !241
  %6 = load i32* %m, align 4, !dbg !242
  %7 = icmp slt i32 %6, 24, !dbg !242
  %8 = zext i1 %7 to i32, !dbg !242
  %9 = call i32 (i32*, i32, ...)* bitcast (i32 (...)* @klee_prefer_cex to i32 (i32*, i32, ...)*)(i32* %m, i32 %8), !dbg !242
  %10 = load i32* %m, align 4, !dbg !243
  %11 = icmp sgt i32 %10, 2, !dbg !243
  %12 = zext i1 %11 to i32, !dbg !243
  %13 = call i32 (i32*, i32, ...)* bitcast (i32 (...)* @klee_prefer_cex to i32 (i32*, i32, ...)*)(i32* %m, i32 %12), !dbg !243
  store i32 8, i32* %m, align 4, !dbg !244
  %14 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !245
  %15 = load i32* %len, align 4, !dbg !245
  %16 = call i32 (i8*, i32, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i8*, i32, i8*, ...)*)(i8* %14, i32 %15, i8* getelementptr inbounds ([4 x i8]* @.str5, i32 0, i32 0)), !dbg !245
  store i32 0, i32* %result, align 4, !dbg !246
  store i32 0, i32* %idata, align 4, !dbg !247
  %17 = call i32 (i32*, i32, i8*, ...)* bitcast (i32 (...)* @klee_make_symbolic to i32 (i32*, i32, i8*, ...)*)(i32* %idata, i32 4, i8* getelementptr inbounds ([2 x i8]* @.str6, i32 0, i32 0)), !dbg !248
  %18 = bitcast i32* %result to i8*, !dbg !249
  %19 = getelementptr inbounds [96 x i8]* %key, i32 0, i32 0, !dbg !249
  %20 = bitcast i32* %idata to i8*, !dbg !249
  %21 = load i32* %n, align 4, !dbg !249
  %22 = mul nsw i32 %21, 8, !dbg !249
  %int_cast_to_i64 = zext i32 8 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i64), !dbg !249
  %23 = sdiv i32 %22, 8, !dbg !249
  %24 = load i32* %m, align 4, !dbg !249
  %25 = call i8* @hash(i8* %18, i8* %19, i8* %20, i32 %23, i32 %24), !dbg !249
  %26 = load i32* %result, align 4, !dbg !250
  %27 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str7, i32 0, i32 0), i32 %26), !dbg !250
  %28 = load i32* %result, align 4, !dbg !251
  %29 = icmp ugt i32 %28, 1, !dbg !251
  br i1 %29, label %30, label %38, !dbg !251

; <label>:30                                      ; preds = %0
  %31 = load i32* %result, align 4, !dbg !253
  %32 = load i32* %m, align 4, !dbg !253
  %int_cast_to_i642 = zext i32 %32 to i64
  call void @klee_overshift_check(i64 32, i64 %int_cast_to_i642), !dbg !253
  %33 = shl i32 1, %32, !dbg !253
  %int_cast_to_i641 = zext i32 2 to i64
  call void @klee_div_zero_check(i64 %int_cast_to_i641), !dbg !253
  %34 = sdiv i32 %33, 2, !dbg !253
  %35 = icmp ult i32 %31, %34, !dbg !253
  br i1 %35, label %36, label %38, !dbg !253

; <label>:36                                      ; preds = %30
  %37 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str8, i32 0, i32 0)), !dbg !255
  store i32 1, i32* %1, !dbg !257
  br label %42, !dbg !257

; <label>:38                                      ; preds = %30, %0
  %39 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([17 x i8]* @.str9, i32 0, i32 0)), !dbg !258
  %40 = load i32* %result, align 4, !dbg !260
  %41 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str7, i32 0, i32 0), i32 %40), !dbg !260
  store i32 1, i32* %1, !dbg !261
  br label %42, !dbg !261

; <label>:42                                      ; preds = %38, %36
  %43 = load i32* %1, !dbg !262
  ret i32 %43, !dbg !262
}

declare i32 @klee_make_symbolic(...) #3

declare i32 @klee_prefer_cex(...) #3

; Function Attrs: nounwind ssp uwtable
define void @klee_div_zero_check(i64 %z) #4 {
  %1 = icmp eq i64 %z, 0, !dbg !263
  br i1 %1, label %2, label %3, !dbg !263

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str10, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str111, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str212, i64 0, i64 0)) #7, !dbg !265
  unreachable, !dbg !265

; <label>:3                                       ; preds = %0
  ret void, !dbg !266
}

; Function Attrs: noreturn
declare void @klee_report_error(i8*, i32, i8*, i8*) #5

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #1

; Function Attrs: nounwind ssp uwtable
define i32 @klee_int(i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = bitcast i32* %x to i8*, !dbg !267
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %1, i64 4, i8* %name) #8, !dbg !267
  %2 = load i32* %x, align 4, !dbg !268, !tbaa !269
  ret i32 %2, !dbg !268
}

; Function Attrs: nounwind ssp uwtable
define void @klee_overshift_check(i64 %bitWidth, i64 %shift) #4 {
  %1 = icmp ult i64 %shift, %bitWidth, !dbg !273
  br i1 %1, label %3, label %2, !dbg !273

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str313, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) #7, !dbg !275
  unreachable, !dbg !275

; <label>:3                                       ; preds = %0
  ret void, !dbg !277
}

; Function Attrs: nounwind ssp uwtable
define i32 @klee_range(i32 %start, i32 %end, i8* %name) #4 {
  %x = alloca i32, align 4
  %1 = icmp slt i32 %start, %end, !dbg !278
  br i1 %1, label %3, label %2, !dbg !278

; <label>:2                                       ; preds = %0
  tail call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str614, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) #7, !dbg !280
  unreachable, !dbg !280

; <label>:3                                       ; preds = %0
  %4 = add nsw i32 %start, 1, !dbg !281
  %5 = icmp eq i32 %4, %end, !dbg !281
  br i1 %5, label %21, label %6, !dbg !281

; <label>:6                                       ; preds = %3
  %7 = bitcast i32* %x to i8*, !dbg !283
  call void bitcast (i32 (...)* @klee_make_symbolic to void (i8*, i64, i8*)*)(i8* %7, i64 4, i8* %name) #8, !dbg !283
  %8 = icmp eq i32 %start, 0, !dbg !285
  %9 = load i32* %x, align 4, !dbg !287, !tbaa !269
  br i1 %8, label %10, label %13, !dbg !285

; <label>:10                                      ; preds = %6
  %11 = icmp ult i32 %9, %end, !dbg !287
  %12 = zext i1 %11 to i64, !dbg !287
  call void @klee_assume(i64 %12) #8, !dbg !287
  br label %19, !dbg !289

; <label>:13                                      ; preds = %6
  %14 = icmp sge i32 %9, %start, !dbg !290
  %15 = zext i1 %14 to i64, !dbg !290
  call void @klee_assume(i64 %15) #8, !dbg !290
  %16 = load i32* %x, align 4, !dbg !292, !tbaa !269
  %17 = icmp slt i32 %16, %end, !dbg !292
  %18 = zext i1 %17 to i64, !dbg !292
  call void @klee_assume(i64 %18) #8, !dbg !292
  br label %19

; <label>:19                                      ; preds = %13, %10
  %20 = load i32* %x, align 4, !dbg !293, !tbaa !269
  br label %21, !dbg !293

; <label>:21                                      ; preds = %19, %3
  %.0 = phi i32 [ %20, %19 ], [ %start, %3 ]
  ret i32 %.0, !dbg !294
}

declare void @klee_assume(i64) #6

; Function Attrs: nounwind ssp uwtable
define weak i8* @memcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !295
  br i1 %1, label %._crit_edge, label %overflow.checked, !dbg !295

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
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !297
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !297, !tbaa !298
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !297
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !297
  %wide.load202.unr = load <16 x i8>* %8, align 1, !dbg !297, !tbaa !298
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !297, !tbaa !298
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !297
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load202.unr, <16 x i8>* %11, align 1, !dbg !297, !tbaa !298
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep105 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !297
  %wide.load = load <16 x i8>* %13, align 1, !dbg !297, !tbaa !298
  %next.gep.sum281 = or i64 %index, 16, !dbg !297
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum281, !dbg !297
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !297
  %wide.load202 = load <16 x i8>* %15, align 1, !dbg !297, !tbaa !298
  %16 = bitcast i8* %next.gep105 to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !297, !tbaa !298
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum281, !dbg !297
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load202, <16 x i8>* %18, align 1, !dbg !297, !tbaa !298
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep105.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !297
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !297, !tbaa !298
  %next.gep.sum281.1 = or i64 %index.next, 16, !dbg !297
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum281.1, !dbg !297
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !297
  %wide.load202.1 = load <16 x i8>* %21, align 1, !dbg !297, !tbaa !298
  %22 = bitcast i8* %next.gep105.1 to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !297, !tbaa !298
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum281.1, !dbg !297
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !297
  store <16 x i8> %wide.load202.1, <16 x i8>* %24, align 1, !dbg !297, !tbaa !298
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !299

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
  %26 = add i64 %resume.val8, -1, !dbg !295
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !297
  %28 = load i8* %resume.val, align 1, !dbg !297, !tbaa !298
  %29 = getelementptr inbounds i8* %resume.val5, i64 1, !dbg !297
  store i8 %28, i8* %resume.val5, align 1, !dbg !297, !tbaa !298
  br label %.lr.ph.unr299

.lr.ph.unr299:                                    ; preds = %.lr.ph.unr, %unr.cmp304
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val8, %unr.cmp304 ]
  %30 = add i64 %.01.unr, -1, !dbg !295
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !297
  %32 = load i8* %src.03.unr, align 1, !dbg !297, !tbaa !298
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !297
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !297, !tbaa !298
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr299, %unr.cmp304
  %src.03.unr301 = phi i8* [ %31, %.lr.ph.unr299 ], [ %resume.val, %unr.cmp304 ]
  %dest.02.unr302 = phi i8* [ %33, %.lr.ph.unr299 ], [ %resume.val5, %unr.cmp304 ]
  %.01.unr303 = phi i64 [ %30, %.lr.ph.unr299 ], [ %resume.val8, %unr.cmp304 ]
  %34 = add i64 %.01.unr303, -1, !dbg !295
  %35 = getelementptr inbounds i8* %src.03.unr301, i64 1, !dbg !297
  %36 = load i8* %src.03.unr301, align 1, !dbg !297, !tbaa !298
  %37 = getelementptr inbounds i8* %dest.02.unr302, i64 1, !dbg !297
  store i8 %36, i8* %dest.02.unr302, align 1, !dbg !297, !tbaa !298
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
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !297
  %40 = load i8* %src.03, align 1, !dbg !297, !tbaa !298
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !297
  store i8 %40, i8* %dest.02, align 1, !dbg !297, !tbaa !298
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !297
  %43 = load i8* %39, align 1, !dbg !297, !tbaa !298
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !297
  store i8 %43, i8* %41, align 1, !dbg !297, !tbaa !298
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !297
  %46 = load i8* %42, align 1, !dbg !297, !tbaa !298
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !297
  store i8 %46, i8* %44, align 1, !dbg !297, !tbaa !298
  %48 = add i64 %.01, -4, !dbg !295
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !297
  %50 = load i8* %45, align 1, !dbg !297, !tbaa !298
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !297
  store i8 %50, i8* %47, align 1, !dbg !297, !tbaa !298
  %52 = icmp eq i64 %48, 0, !dbg !295
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !295, !llvm.loop !302

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block, %0
  ret i8* %destaddr, !dbg !303
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memmove(i8* %dst, i8* %src, i64 %count) #4 {
  %1 = icmp eq i8* %src, %dst, !dbg !304
  br i1 %1, label %.loopexit, label %2, !dbg !304

; <label>:2                                       ; preds = %0
  %3 = icmp ugt i8* %src, %dst, !dbg !306
  br i1 %3, label %.preheader, label %56, !dbg !306

.preheader:                                       ; preds = %2
  %4 = icmp eq i64 %count, 0, !dbg !308
  br i1 %4, label %.loopexit, label %overflow.checked227, !dbg !308

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
  %9 = bitcast i8* %src to <16 x i8>*, !dbg !312
  %wide.load445.unr = load <16 x i8>* %9, align 1, !dbg !312, !tbaa !298
  %10 = getelementptr i8* %src, i64 16, !dbg !312
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !312
  %wide.load446.unr = load <16 x i8>* %11, align 1, !dbg !312, !tbaa !298
  %12 = bitcast i8* %dst to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load445.unr, <16 x i8>* %12, align 1, !dbg !312, !tbaa !298
  %13 = getelementptr i8* %dst, i64 16, !dbg !312
  %14 = bitcast i8* %13 to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load446.unr, <16 x i8>* %14, align 1, !dbg !312, !tbaa !298
  br label %vector.body218.preheader.split

vector.body218.preheader.split:                   ; preds = %vector.body218.unr, %vector.body218.preheader
  %index221.unr = phi i64 [ 0, %vector.body218.preheader ], [ 32, %vector.body218.unr ]
  %15 = icmp ult i64 %8, 2
  br i1 %15, label %middle.block219, label %vector.body218

vector.body218:                                   ; preds = %vector.body218.preheader.split, %vector.body218
  %index221 = phi i64 [ %index.next245.1, %vector.body218 ], [ %index221.unr, %vector.body218.preheader.split ]
  %next.gep247 = getelementptr i8* %src, i64 %index221
  %next.gep344 = getelementptr i8* %dst, i64 %index221
  %16 = bitcast i8* %next.gep247 to <16 x i8>*, !dbg !312
  %wide.load445 = load <16 x i8>* %16, align 1, !dbg !312, !tbaa !298
  %next.gep247.sum594 = or i64 %index221, 16, !dbg !312
  %17 = getelementptr i8* %src, i64 %next.gep247.sum594, !dbg !312
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !312
  %wide.load446 = load <16 x i8>* %18, align 1, !dbg !312, !tbaa !298
  %19 = bitcast i8* %next.gep344 to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load445, <16 x i8>* %19, align 1, !dbg !312, !tbaa !298
  %20 = getelementptr i8* %dst, i64 %next.gep247.sum594, !dbg !312
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load446, <16 x i8>* %21, align 1, !dbg !312, !tbaa !298
  %index.next245 = add i64 %index221, 32
  %next.gep247.1 = getelementptr i8* %src, i64 %index.next245
  %next.gep344.1 = getelementptr i8* %dst, i64 %index.next245
  %22 = bitcast i8* %next.gep247.1 to <16 x i8>*, !dbg !312
  %wide.load445.1 = load <16 x i8>* %22, align 1, !dbg !312, !tbaa !298
  %next.gep247.sum594.1 = or i64 %index.next245, 16, !dbg !312
  %23 = getelementptr i8* %src, i64 %next.gep247.sum594.1, !dbg !312
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !312
  %wide.load446.1 = load <16 x i8>* %24, align 1, !dbg !312, !tbaa !298
  %25 = bitcast i8* %next.gep344.1 to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load445.1, <16 x i8>* %25, align 1, !dbg !312, !tbaa !298
  %26 = getelementptr i8* %dst, i64 %next.gep247.sum594.1, !dbg !312
  %27 = bitcast i8* %26 to <16 x i8>*, !dbg !312
  store <16 x i8> %wide.load446.1, <16 x i8>* %27, align 1, !dbg !312, !tbaa !298
  %index.next245.1 = add i64 %index221, 64
  %28 = icmp eq i64 %index.next245.1, %n.vec224
  br i1 %28, label %middle.block219, label %vector.body218, !llvm.loop !314

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
  %29 = add i64 %resume.val240, -1, !dbg !308
  %30 = getelementptr inbounds i8* %resume.val235, i64 1, !dbg !312
  %31 = load i8* %resume.val235, align 1, !dbg !312, !tbaa !298
  %32 = getelementptr inbounds i8* %resume.val237, i64 1, !dbg !312
  store i8 %31, i8* %resume.val237, align 1, !dbg !312, !tbaa !298
  br label %.lr.ph.unr613

.lr.ph.unr613:                                    ; preds = %.lr.ph.unr, %unr.cmp618
  %b.05.unr = phi i8* [ %30, %.lr.ph.unr ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr = phi i8* [ %32, %.lr.ph.unr ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr = phi i64 [ %29, %.lr.ph.unr ], [ %resume.val240, %unr.cmp618 ]
  %33 = add i64 %.03.unr, -1, !dbg !308
  %34 = getelementptr inbounds i8* %b.05.unr, i64 1, !dbg !312
  %35 = load i8* %b.05.unr, align 1, !dbg !312, !tbaa !298
  %36 = getelementptr inbounds i8* %a.04.unr, i64 1, !dbg !312
  store i8 %35, i8* %a.04.unr, align 1, !dbg !312, !tbaa !298
  br label %.lr.ph.unr614

.lr.ph.unr614:                                    ; preds = %.lr.ph.unr613, %unr.cmp618
  %b.05.unr615 = phi i8* [ %34, %.lr.ph.unr613 ], [ %resume.val235, %unr.cmp618 ]
  %a.04.unr616 = phi i8* [ %36, %.lr.ph.unr613 ], [ %resume.val237, %unr.cmp618 ]
  %.03.unr617 = phi i64 [ %33, %.lr.ph.unr613 ], [ %resume.val240, %unr.cmp618 ]
  %37 = add i64 %.03.unr617, -1, !dbg !308
  %38 = getelementptr inbounds i8* %b.05.unr615, i64 1, !dbg !312
  %39 = load i8* %b.05.unr615, align 1, !dbg !312, !tbaa !298
  %40 = getelementptr inbounds i8* %a.04.unr616, i64 1, !dbg !312
  store i8 %39, i8* %a.04.unr616, align 1, !dbg !312, !tbaa !298
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
  %42 = getelementptr inbounds i8* %b.05, i64 1, !dbg !312
  %43 = load i8* %b.05, align 1, !dbg !312, !tbaa !298
  %44 = getelementptr inbounds i8* %a.04, i64 1, !dbg !312
  store i8 %43, i8* %a.04, align 1, !dbg !312, !tbaa !298
  %45 = getelementptr inbounds i8* %b.05, i64 2, !dbg !312
  %46 = load i8* %42, align 1, !dbg !312, !tbaa !298
  %47 = getelementptr inbounds i8* %a.04, i64 2, !dbg !312
  store i8 %46, i8* %44, align 1, !dbg !312, !tbaa !298
  %48 = getelementptr inbounds i8* %b.05, i64 3, !dbg !312
  %49 = load i8* %45, align 1, !dbg !312, !tbaa !298
  %50 = getelementptr inbounds i8* %a.04, i64 3, !dbg !312
  store i8 %49, i8* %47, align 1, !dbg !312, !tbaa !298
  %51 = add i64 %.03, -4, !dbg !308
  %52 = getelementptr inbounds i8* %b.05, i64 4, !dbg !312
  %53 = load i8* %48, align 1, !dbg !312, !tbaa !298
  %54 = getelementptr inbounds i8* %a.04, i64 4, !dbg !312
  store i8 %53, i8* %50, align 1, !dbg !312, !tbaa !298
  %55 = icmp eq i64 %51, 0, !dbg !308
  br i1 %55, label %.loopexit, label %.lr.ph, !dbg !308, !llvm.loop !315

; <label>:56                                      ; preds = %2
  %57 = add i64 %count, -1, !dbg !316
  %58 = icmp eq i64 %count, 0, !dbg !318
  br i1 %58, label %.loopexit, label %.lr.ph9, !dbg !318

.lr.ph9:                                          ; preds = %56
  %59 = getelementptr inbounds i8* %src, i64 %57, !dbg !321
  %60 = getelementptr inbounds i8* %dst, i64 %57, !dbg !316
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
  %next.gep.sum = add i64 %.sum448, -15, !dbg !322
  %61 = getelementptr i8* %src, i64 %next.gep.sum, !dbg !322
  %62 = bitcast i8* %61 to <16 x i8>*, !dbg !322
  %wide.load = load <16 x i8>* %62, align 1, !dbg !322, !tbaa !298
  %.sum513 = add i64 %.sum448, -31, !dbg !322
  %63 = getelementptr i8* %src, i64 %.sum513, !dbg !322
  %64 = bitcast i8* %63 to <16 x i8>*, !dbg !322
  %wide.load211 = load <16 x i8>* %64, align 1, !dbg !322, !tbaa !298
  %65 = getelementptr i8* %dst, i64 %next.gep.sum, !dbg !322
  %66 = bitcast i8* %65 to <16 x i8>*, !dbg !322
  store <16 x i8> %wide.load, <16 x i8>* %66, align 1, !dbg !322, !tbaa !298
  %67 = getelementptr i8* %dst, i64 %.sum513, !dbg !322
  %68 = bitcast i8* %67 to <16 x i8>*, !dbg !322
  store <16 x i8> %wide.load211, <16 x i8>* %68, align 1, !dbg !322, !tbaa !298
  %index.next = add i64 %index, 32
  %69 = icmp eq i64 %index.next, %n.vec
  br i1 %69, label %middle.block, label %vector.body, !llvm.loop !324

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
  %71 = add i64 %resume.val16, -1, !dbg !318
  %.sum1 = add i64 %70, -1, !dbg !322
  %72 = getelementptr inbounds i8* %src, i64 %.sum1, !dbg !322
  %73 = load i8* %resume.val, align 1, !dbg !322, !tbaa !298
  %74 = getelementptr inbounds i8* %dst, i64 %.sum1, !dbg !322
  store i8 %73, i8* %resume.val12, align 1, !dbg !322, !tbaa !298
  br label %scalar.ph.unr631

scalar.ph.unr631:                                 ; preds = %scalar.ph.unr, %unr.cmp638
  %b.18.unr = phi i8* [ %72, %scalar.ph.unr ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr = phi i8* [ %74, %scalar.ph.unr ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr = phi i64 [ %71, %scalar.ph.unr ], [ %resume.val16, %unr.cmp638 ]
  %75 = add i64 %.16.unr, -1, !dbg !318
  %76 = getelementptr inbounds i8* %b.18.unr, i64 -1, !dbg !322
  %77 = load i8* %b.18.unr, align 1, !dbg !322, !tbaa !298
  %78 = getelementptr inbounds i8* %a.17.unr, i64 -1, !dbg !322
  store i8 %77, i8* %a.17.unr, align 1, !dbg !322, !tbaa !298
  br label %scalar.ph.unr634

scalar.ph.unr634:                                 ; preds = %scalar.ph.unr631, %unr.cmp638
  %b.18.unr635 = phi i8* [ %76, %scalar.ph.unr631 ], [ %resume.val, %unr.cmp638 ]
  %a.17.unr636 = phi i8* [ %78, %scalar.ph.unr631 ], [ %resume.val12, %unr.cmp638 ]
  %.16.unr637 = phi i64 [ %75, %scalar.ph.unr631 ], [ %resume.val16, %unr.cmp638 ]
  %79 = add i64 %.16.unr637, -1, !dbg !318
  %80 = getelementptr inbounds i8* %b.18.unr635, i64 -1, !dbg !322
  %81 = load i8* %b.18.unr635, align 1, !dbg !322, !tbaa !298
  %82 = getelementptr inbounds i8* %a.17.unr636, i64 -1, !dbg !322
  store i8 %81, i8* %a.17.unr636, align 1, !dbg !322, !tbaa !298
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
  %84 = getelementptr inbounds i8* %b.18, i64 -1, !dbg !322
  %85 = load i8* %b.18, align 1, !dbg !322, !tbaa !298
  %86 = getelementptr inbounds i8* %a.17, i64 -1, !dbg !322
  store i8 %85, i8* %a.17, align 1, !dbg !322, !tbaa !298
  %87 = getelementptr inbounds i8* %b.18, i64 -2, !dbg !322
  %88 = load i8* %84, align 1, !dbg !322, !tbaa !298
  %89 = getelementptr inbounds i8* %a.17, i64 -2, !dbg !322
  store i8 %88, i8* %86, align 1, !dbg !322, !tbaa !298
  %90 = getelementptr inbounds i8* %b.18, i64 -3, !dbg !322
  %91 = load i8* %87, align 1, !dbg !322, !tbaa !298
  %92 = getelementptr inbounds i8* %a.17, i64 -3, !dbg !322
  store i8 %91, i8* %89, align 1, !dbg !322, !tbaa !298
  %93 = add i64 %.16, -4, !dbg !318
  %94 = getelementptr inbounds i8* %b.18, i64 -4, !dbg !322
  %95 = load i8* %90, align 1, !dbg !322, !tbaa !298
  %96 = getelementptr inbounds i8* %a.17, i64 -4, !dbg !322
  store i8 %95, i8* %92, align 1, !dbg !322, !tbaa !298
  %97 = icmp eq i64 %93, 0, !dbg !318
  br i1 %97, label %.loopexit, label %scalar.ph, !dbg !318, !llvm.loop !325

.loopexit:                                        ; preds = %scalar.ph, %.lr.ph, %scalar.ph.preheader.split, %middle.block, %56, %.lr.ph.preheader.split, %middle.block219, %.preheader, %0
  ret i8* %dst, !dbg !326
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) #4 {
  %1 = icmp eq i64 %len, 0, !dbg !327
  br i1 %1, label %53, label %overflow.checked, !dbg !327

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
  %6 = bitcast i8* %srcaddr to <16 x i8>*, !dbg !329
  %wide.load.unr = load <16 x i8>* %6, align 1, !dbg !329, !tbaa !298
  %7 = getelementptr i8* %srcaddr, i64 16, !dbg !329
  %8 = bitcast i8* %7 to <16 x i8>*, !dbg !329
  %wide.load203.unr = load <16 x i8>* %8, align 1, !dbg !329, !tbaa !298
  %9 = bitcast i8* %destaddr to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load.unr, <16 x i8>* %9, align 1, !dbg !329, !tbaa !298
  %10 = getelementptr i8* %destaddr, i64 16, !dbg !329
  %11 = bitcast i8* %10 to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load203.unr, <16 x i8>* %11, align 1, !dbg !329, !tbaa !298
  br label %vector.body.preheader.split

vector.body.preheader.split:                      ; preds = %vector.body.unr, %vector.body.preheader
  %index.unr = phi i64 [ 0, %vector.body.preheader ], [ 32, %vector.body.unr ]
  %12 = icmp ult i64 %5, 2
  br i1 %12, label %middle.block, label %vector.body

vector.body:                                      ; preds = %vector.body.preheader.split, %vector.body
  %index = phi i64 [ %index.next.1, %vector.body ], [ %index.unr, %vector.body.preheader.split ]
  %next.gep = getelementptr i8* %srcaddr, i64 %index
  %next.gep106 = getelementptr i8* %destaddr, i64 %index
  %13 = bitcast i8* %next.gep to <16 x i8>*, !dbg !329
  %wide.load = load <16 x i8>* %13, align 1, !dbg !329, !tbaa !298
  %next.gep.sum282 = or i64 %index, 16, !dbg !329
  %14 = getelementptr i8* %srcaddr, i64 %next.gep.sum282, !dbg !329
  %15 = bitcast i8* %14 to <16 x i8>*, !dbg !329
  %wide.load203 = load <16 x i8>* %15, align 1, !dbg !329, !tbaa !298
  %16 = bitcast i8* %next.gep106 to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load, <16 x i8>* %16, align 1, !dbg !329, !tbaa !298
  %17 = getelementptr i8* %destaddr, i64 %next.gep.sum282, !dbg !329
  %18 = bitcast i8* %17 to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load203, <16 x i8>* %18, align 1, !dbg !329, !tbaa !298
  %index.next = add i64 %index, 32
  %next.gep.1 = getelementptr i8* %srcaddr, i64 %index.next
  %next.gep106.1 = getelementptr i8* %destaddr, i64 %index.next
  %19 = bitcast i8* %next.gep.1 to <16 x i8>*, !dbg !329
  %wide.load.1 = load <16 x i8>* %19, align 1, !dbg !329, !tbaa !298
  %next.gep.sum282.1 = or i64 %index.next, 16, !dbg !329
  %20 = getelementptr i8* %srcaddr, i64 %next.gep.sum282.1, !dbg !329
  %21 = bitcast i8* %20 to <16 x i8>*, !dbg !329
  %wide.load203.1 = load <16 x i8>* %21, align 1, !dbg !329, !tbaa !298
  %22 = bitcast i8* %next.gep106.1 to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load.1, <16 x i8>* %22, align 1, !dbg !329, !tbaa !298
  %23 = getelementptr i8* %destaddr, i64 %next.gep.sum282.1, !dbg !329
  %24 = bitcast i8* %23 to <16 x i8>*, !dbg !329
  store <16 x i8> %wide.load203.1, <16 x i8>* %24, align 1, !dbg !329, !tbaa !298
  %index.next.1 = add i64 %index, 64
  %25 = icmp eq i64 %index.next.1, %n.vec
  br i1 %25, label %middle.block, label %vector.body, !llvm.loop !330

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
  %26 = add i64 %resume.val9, -1, !dbg !327
  %27 = getelementptr inbounds i8* %resume.val, i64 1, !dbg !329
  %28 = load i8* %resume.val, align 1, !dbg !329, !tbaa !298
  %29 = getelementptr inbounds i8* %resume.val6, i64 1, !dbg !329
  store i8 %28, i8* %resume.val6, align 1, !dbg !329, !tbaa !298
  br label %.lr.ph.unr300

.lr.ph.unr300:                                    ; preds = %.lr.ph.unr, %unr.cmp305
  %src.03.unr = phi i8* [ %27, %.lr.ph.unr ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr = phi i8* [ %29, %.lr.ph.unr ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr = phi i64 [ %26, %.lr.ph.unr ], [ %resume.val9, %unr.cmp305 ]
  %30 = add i64 %.01.unr, -1, !dbg !327
  %31 = getelementptr inbounds i8* %src.03.unr, i64 1, !dbg !329
  %32 = load i8* %src.03.unr, align 1, !dbg !329, !tbaa !298
  %33 = getelementptr inbounds i8* %dest.02.unr, i64 1, !dbg !329
  store i8 %32, i8* %dest.02.unr, align 1, !dbg !329, !tbaa !298
  br label %.lr.ph.unr301

.lr.ph.unr301:                                    ; preds = %.lr.ph.unr300, %unr.cmp305
  %src.03.unr302 = phi i8* [ %31, %.lr.ph.unr300 ], [ %resume.val, %unr.cmp305 ]
  %dest.02.unr303 = phi i8* [ %33, %.lr.ph.unr300 ], [ %resume.val6, %unr.cmp305 ]
  %.01.unr304 = phi i64 [ %30, %.lr.ph.unr300 ], [ %resume.val9, %unr.cmp305 ]
  %34 = add i64 %.01.unr304, -1, !dbg !327
  %35 = getelementptr inbounds i8* %src.03.unr302, i64 1, !dbg !329
  %36 = load i8* %src.03.unr302, align 1, !dbg !329, !tbaa !298
  %37 = getelementptr inbounds i8* %dest.02.unr303, i64 1, !dbg !329
  store i8 %36, i8* %dest.02.unr303, align 1, !dbg !329, !tbaa !298
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
  %39 = getelementptr inbounds i8* %src.03, i64 1, !dbg !329
  %40 = load i8* %src.03, align 1, !dbg !329, !tbaa !298
  %41 = getelementptr inbounds i8* %dest.02, i64 1, !dbg !329
  store i8 %40, i8* %dest.02, align 1, !dbg !329, !tbaa !298
  %42 = getelementptr inbounds i8* %src.03, i64 2, !dbg !329
  %43 = load i8* %39, align 1, !dbg !329, !tbaa !298
  %44 = getelementptr inbounds i8* %dest.02, i64 2, !dbg !329
  store i8 %43, i8* %41, align 1, !dbg !329, !tbaa !298
  %45 = getelementptr inbounds i8* %src.03, i64 3, !dbg !329
  %46 = load i8* %42, align 1, !dbg !329, !tbaa !298
  %47 = getelementptr inbounds i8* %dest.02, i64 3, !dbg !329
  store i8 %46, i8* %44, align 1, !dbg !329, !tbaa !298
  %48 = add i64 %.01, -4, !dbg !327
  %49 = getelementptr inbounds i8* %src.03, i64 4, !dbg !329
  %50 = load i8* %45, align 1, !dbg !329, !tbaa !298
  %51 = getelementptr inbounds i8* %dest.02, i64 4, !dbg !329
  store i8 %50, i8* %47, align 1, !dbg !329, !tbaa !298
  %52 = icmp eq i64 %48, 0, !dbg !327
  br i1 %52, label %._crit_edge, label %.lr.ph, !dbg !327, !llvm.loop !331

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph.preheader.split, %middle.block
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %53, !dbg !327

; <label>:53                                      ; preds = %._crit_edge, %0
  %dest.0.lcssa = phi i8* [ %scevgep, %._crit_edge ], [ %destaddr, %0 ]
  ret i8* %dest.0.lcssa, !dbg !332
}

; Function Attrs: nounwind ssp uwtable
define weak i8* @memset(i8* %dst, i32 %s, i64 %count) #4 {
  %1 = icmp eq i64 %count, 0, !dbg !333
  br i1 %1, label %._crit_edge, label %.lr.ph, !dbg !333

.lr.ph:                                           ; preds = %0
  %2 = trunc i32 %s to i8, !dbg !335
  %xtraiter = and i64 %count, 3
  switch i64 %xtraiter, label %3 [
    i64 0, label %.lr.ph.split
    i64 1, label %9
    i64 2, label %6
  ]

; <label>:3                                       ; preds = %.lr.ph
  %4 = add i64 %count, -1, !dbg !333
  %5 = getelementptr inbounds i8* %dst, i64 1, !dbg !335
  store volatile i8 %2, i8* %dst, align 1, !dbg !335, !tbaa !298
  br label %6

; <label>:6                                       ; preds = %3, %.lr.ph
  %a.02.unr = phi i8* [ %5, %3 ], [ %dst, %.lr.ph ]
  %.01.unr = phi i64 [ %4, %3 ], [ %count, %.lr.ph ]
  %7 = add i64 %.01.unr, -1, !dbg !333
  %8 = getelementptr inbounds i8* %a.02.unr, i64 1, !dbg !335
  store volatile i8 %2, i8* %a.02.unr, align 1, !dbg !335, !tbaa !298
  br label %9

; <label>:9                                       ; preds = %6, %.lr.ph
  %a.02.unr3 = phi i8* [ %8, %6 ], [ %dst, %.lr.ph ]
  %.01.unr4 = phi i64 [ %7, %6 ], [ %count, %.lr.ph ]
  %10 = add i64 %.01.unr4, -1, !dbg !333
  %11 = getelementptr inbounds i8* %a.02.unr3, i64 1, !dbg !335
  store volatile i8 %2, i8* %a.02.unr3, align 1, !dbg !335, !tbaa !298
  br label %.lr.ph.split

.lr.ph.split:                                     ; preds = %9, %.lr.ph
  %a.02.unr7 = phi i8* [ %dst, %.lr.ph ], [ %11, %9 ]
  %.01.unr8 = phi i64 [ %count, %.lr.ph ], [ %10, %9 ]
  %12 = icmp ult i64 %count, 4
  br i1 %12, label %._crit_edge, label %.lr.ph.split.split

.lr.ph.split.split:                               ; preds = %.lr.ph.split, %.lr.ph.split.split
  %a.02 = phi i8* [ %17, %.lr.ph.split.split ], [ %a.02.unr7, %.lr.ph.split ]
  %.01 = phi i64 [ %16, %.lr.ph.split.split ], [ %.01.unr8, %.lr.ph.split ]
  %13 = getelementptr inbounds i8* %a.02, i64 1, !dbg !335
  store volatile i8 %2, i8* %a.02, align 1, !dbg !335, !tbaa !298
  %14 = getelementptr inbounds i8* %a.02, i64 2, !dbg !335
  store volatile i8 %2, i8* %13, align 1, !dbg !335, !tbaa !298
  %15 = getelementptr inbounds i8* %a.02, i64 3, !dbg !335
  store volatile i8 %2, i8* %14, align 1, !dbg !335, !tbaa !298
  %16 = add i64 %.01, -4, !dbg !333
  %17 = getelementptr inbounds i8* %a.02, i64 4, !dbg !335
  store volatile i8 %2, i8* %15, align 1, !dbg !335, !tbaa !298
  %18 = icmp eq i64 %16, 0, !dbg !333
  br i1 %18, label %._crit_edge, label %.lr.ph.split.split, !dbg !333

._crit_edge:                                      ; preds = %.lr.ph.split.split, %.lr.ph.split, %0
  ret i8* %dst, !dbg !336
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
!14 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 88, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 88} ; [ DW_TAG_s
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
!134 = metadata !{i32 786443, metadata !1, metadata !135, i32 10, i32 12, i32 2, i32 21} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!135 = metadata !{i32 786443, metadata !1, metadata !132, i32 10, i32 12, i32 1, i32 20} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!136 = metadata !{i32 11, i32 13, metadata !137, null}
!137 = metadata !{i32 786443, metadata !1, metadata !132, i32 10, i32 37, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!138 = metadata !{i32 13, i32 15, metadata !137, null}
!139 = metadata !{i32 10, i32 32, metadata !132, null}
!140 = metadata !{i32 16, i32 8, metadata !4, null}
!141 = metadata !{i32 23, i32 2, metadata !11, null}
!142 = metadata !{i32 24, i32 2, metadata !11, null}
!143 = metadata !{i32 25, i32 2, metadata !11, null}
!144 = metadata !{i32 26, i32 6, metadata !145, null}
!145 = metadata !{i32 786443, metadata !1, metadata !11, i32 26, i32 6, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!146 = metadata !{i32 26, i32 6, metadata !147, null}
!147 = metadata !{i32 786443, metadata !1, metadata !145, i32 26, i32 6, i32 2, i32 23} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!148 = metadata !{i32 26, i32 30, metadata !149, null}
!149 = metadata !{i32 786443, metadata !1, metadata !150, i32 26, i32 30, i32 3, i32 24} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!150 = metadata !{i32 786443, metadata !1, metadata !145, i32 26, i32 30, i32 1, i32 22} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!151 = metadata !{i32 31, i32 6, metadata !11, null}
!152 = metadata !{i32 34, i32 8, metadata !153, null}
!153 = metadata !{i32 786443, metadata !1, metadata !11, i32 34, i32 3, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!154 = metadata !{i32 34, i32 8, metadata !155, null}
!155 = metadata !{i32 786443, metadata !1, metadata !156, i32 34, i32 8, i32 2, i32 32} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!156 = metadata !{i32 786443, metadata !1, metadata !153, i32 34, i32 8, i32 1, i32 25} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!157 = metadata !{i32 35, i32 3, metadata !158, null}
!158 = metadata !{i32 786443, metadata !1, metadata !153, i32 34, i32 29, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!159 = metadata !{i32 36, i32 3, metadata !158, null}
!160 = metadata !{i32 37, i32 3, metadata !158, null}
!161 = metadata !{i32 38, i32 7, metadata !162, null}
!162 = metadata !{i32 786443, metadata !1, metadata !158, i32 38, i32 3, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!163 = metadata !{i32 38, i32 7, metadata !164, null}
!164 = metadata !{i32 786443, metadata !1, metadata !165, i32 38, i32 7, i32 2, i32 31} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!165 = metadata !{i32 786443, metadata !1, metadata !162, i32 38, i32 7, i32 1, i32 26} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!166 = metadata !{i32 39, i32 4, metadata !167, null}
!167 = metadata !{i32 786443, metadata !1, metadata !162, i32 38, i32 26, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!168 = metadata !{i32 40, i32 8, metadata !169, null}
!169 = metadata !{i32 786443, metadata !1, metadata !167, i32 40, i32 4, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!170 = metadata !{i32 40, i32 8, metadata !171, null}
!171 = metadata !{i32 786443, metadata !1, metadata !172, i32 40, i32 8, i32 2, i32 30} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!172 = metadata !{i32 786443, metadata !1, metadata !169, i32 40, i32 8, i32 1, i32 27} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!173 = metadata !{i32 41, i32 5, metadata !174, null}
!174 = metadata !{i32 786443, metadata !1, metadata !169, i32 40, i32 20, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!175 = metadata !{i32 42, i32 5, metadata !174, null}
!176 = metadata !{i32 43, i32 5, metadata !174, null}
!177 = metadata !{i32 44, i32 5, metadata !174, null}
!178 = metadata !{i32 45, i32 5, metadata !174, null}
!179 = metadata !{i32 46, i32 5, metadata !174, null}
!180 = metadata !{i32 47, i32 5, metadata !174, null}
!181 = metadata !{i32 48, i32 5, metadata !174, null}
!182 = metadata !{i32 49, i32 5, metadata !174, null}
!183 = metadata !{i32 50, i32 9, metadata !184, null}
!184 = metadata !{i32 786443, metadata !1, metadata !174, i32 50, i32 5, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!185 = metadata !{i32 50, i32 9, metadata !186, null}
!186 = metadata !{i32 786443, metadata !1, metadata !187, i32 50, i32 9, i32 2, i32 29} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!187 = metadata !{i32 786443, metadata !1, metadata !184, i32 50, i32 9, i32 1, i32 28} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!188 = metadata !{i32 51, i32 6, metadata !189, null}
!189 = metadata !{i32 786443, metadata !1, metadata !184, i32 50, i32 28, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!190 = metadata !{i32 52, i32 6, metadata !189, null}
!191 = metadata !{i32 50, i32 24, metadata !184, null}
!192 = metadata !{i32 40, i32 16, metadata !169, null}
!193 = metadata !{i32 56, i32 4, metadata !167, null}
!194 = metadata !{i32 57, i32 4, metadata !167, null}
!195 = metadata !{i32 58, i32 4, metadata !167, null} ; [ DW_TAG_imported_module ]
!196 = metadata !{i32 38, i32 22, metadata !162, null}
!197 = metadata !{i32 34, i32 25, metadata !153, null}
!198 = metadata !{i32 61, i32 3, metadata !11, null}
!199 = metadata !{i32 62, i32 3, metadata !11, null}
!200 = metadata !{i32 63, i32 7, metadata !201, null}
!201 = metadata !{i32 786443, metadata !1, metadata !11, i32 63, i32 3, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!202 = metadata !{i32 63, i32 7, metadata !203, null}
!203 = metadata !{i32 786443, metadata !1, metadata !204, i32 63, i32 7, i32 2, i32 38} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!204 = metadata !{i32 786443, metadata !1, metadata !201, i32 63, i32 7, i32 1, i32 33} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!205 = metadata !{i32 64, i32 4, metadata !206, null}
!206 = metadata !{i32 786443, metadata !1, metadata !201, i32 63, i32 30, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!207 = metadata !{i32 65, i32 8, metadata !208, null}
!208 = metadata !{i32 786443, metadata !1, metadata !206, i32 65, i32 4, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!209 = metadata !{i32 65, i32 8, metadata !210, null}
!210 = metadata !{i32 786443, metadata !1, metadata !211, i32 65, i32 8, i32 2, i32 37} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!211 = metadata !{i32 786443, metadata !1, metadata !208, i32 65, i32 8, i32 1, i32 34} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!212 = metadata !{i32 66, i32 5, metadata !213, null}
!213 = metadata !{i32 786443, metadata !1, metadata !208, i32 65, i32 20, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!214 = metadata !{i32 67, i32 5, metadata !213, null}
!215 = metadata !{i32 68, i32 5, metadata !213, null}
!216 = metadata !{i32 69, i32 5, metadata !213, null}
!217 = metadata !{i32 70, i32 5, metadata !213, null}
!218 = metadata !{i32 71, i32 5, metadata !213, null}
!219 = metadata !{i32 72, i32 5, metadata !213, null}
!220 = metadata !{i32 73, i32 5, metadata !213, null}
!221 = metadata !{i32 74, i32 5, metadata !213, null}
!222 = metadata !{i32 75, i32 9, metadata !223, null}
!223 = metadata !{i32 786443, metadata !1, metadata !213, i32 75, i32 5, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!224 = metadata !{i32 75, i32 9, metadata !225, null}
!225 = metadata !{i32 786443, metadata !1, metadata !226, i32 75, i32 9, i32 2, i32 36} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!226 = metadata !{i32 786443, metadata !1, metadata !223, i32 75, i32 9, i32 1, i32 35} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!227 = metadata !{i32 76, i32 6, metadata !228, null}
!228 = metadata !{i32 786443, metadata !1, metadata !223, i32 75, i32 28, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!229 = metadata !{i32 77, i32 6, metadata !228, null}
!230 = metadata !{i32 75, i32 24, metadata !223, null}
!231 = metadata !{i32 65, i32 16, metadata !208, null}
!232 = metadata !{i32 80, i32 4, metadata !206, null}
!233 = metadata !{i32 81, i32 4, metadata !206, null}
!234 = metadata !{i32 82, i32 4, metadata !206, null}
!235 = metadata !{i32 63, i32 26, metadata !201, null}
!236 = metadata !{i32 85, i32 1, metadata !11, null}
!237 = metadata !{i32 89, i32 2, metadata !14, null}
!238 = metadata !{i32 91, i32 2, metadata !14, null}
!239 = metadata !{i32 92, i32 2, metadata !14, null}
!240 = metadata !{i32 94, i32 2, metadata !14, null}
!241 = metadata !{i32 96, i32 2, metadata !14, null}
!242 = metadata !{i32 97, i32 2, metadata !14, null}
!243 = metadata !{i32 98, i32 3, metadata !14, null}
!244 = metadata !{i32 99, i32 2, metadata !14, null}
!245 = metadata !{i32 100, i32 3, metadata !14, null}
!246 = metadata !{i32 102, i32 2, metadata !14, null}
!247 = metadata !{i32 103, i32 2, metadata !14, null}
!248 = metadata !{i32 104, i32 2, metadata !14, null}
!249 = metadata !{i32 105, i32 2, metadata !14, null}
!250 = metadata !{i32 106, i32 2, metadata !14, null}
!251 = metadata !{i32 107, i32 5, metadata !252, null}
!252 = metadata !{i32 786443, metadata !1, metadata !14, i32 107, i32 5, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!253 = metadata !{i32 107, i32 5, metadata !254, null}
!254 = metadata !{i32 786443, metadata !1, metadata !252, i32 107, i32 5, i32 1, i32 39} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!255 = metadata !{i32 108, i32 3, metadata !256, null}
!256 = metadata !{i32 786443, metadata !1, metadata !252, i32 107, i32 33, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!257 = metadata !{i32 109, i32 3, metadata !256, null}
!258 = metadata !{i32 111, i32 3, metadata !259, null}
!259 = metadata !{i32 786443, metadata !1, metadata !252, i32 110, i32 7, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/analyzer/hash/hash.c]
!260 = metadata !{i32 112, i32 3, metadata !259, null}
!261 = metadata !{i32 116, i32 2, metadata !14, null}
!262 = metadata !{i32 118, i32 1, metadata !14, null}
!263 = metadata !{i32 13, i32 7, metadata !264, null}
!264 = metadata !{i32 786443, metadata !22, metadata !21, i32 13, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_div_zero_check.c]
!265 = metadata !{i32 14, i32 5, metadata !264, null}
!266 = metadata !{i32 15, i32 1, metadata !21, null}
!267 = metadata !{i32 15, i32 3, metadata !32, null}
!268 = metadata !{i32 16, i32 3, metadata !32, null}
!269 = metadata !{metadata !270, metadata !270, i64 0}
!270 = metadata !{metadata !"int", metadata !271, i64 0}
!271 = metadata !{metadata !"omnipotent char", metadata !272, i64 0}
!272 = metadata !{metadata !"Simple C/C++ TBAA"}
!273 = metadata !{i32 21, i32 7, metadata !274, null}
!274 = metadata !{i32 786443, metadata !46, metadata !45, i32 21, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!275 = metadata !{i32 27, i32 5, metadata !276, null}
!276 = metadata !{i32 786443, metadata !46, metadata !274, i32 21, i32 26, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_overshift_check.c]
!277 = metadata !{i32 29, i32 1, metadata !45, null}
!278 = metadata !{i32 16, i32 7, metadata !279, null}
!279 = metadata !{i32 786443, metadata !58, metadata !57, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!280 = metadata !{i32 17, i32 5, metadata !279, null}
!281 = metadata !{i32 19, i32 7, metadata !282, null}
!282 = metadata !{i32 786443, metadata !58, metadata !57, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!283 = metadata !{i32 22, i32 5, metadata !284, null}
!284 = metadata !{i32 786443, metadata !58, metadata !282, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!285 = metadata !{i32 25, i32 9, metadata !286, null}
!286 = metadata !{i32 786443, metadata !58, metadata !284, i32 25, i32 9, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!287 = metadata !{i32 26, i32 7, metadata !288, null}
!288 = metadata !{i32 786443, metadata !58, metadata !286, i32 25, i32 19, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!289 = metadata !{i32 27, i32 5, metadata !288, null}
!290 = metadata !{i32 28, i32 7, metadata !291, null}
!291 = metadata !{i32 786443, metadata !58, metadata !286, i32 27, i32 12, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/klee_range.c]
!292 = metadata !{i32 29, i32 7, metadata !291, null}
!293 = metadata !{i32 32, i32 5, metadata !284, null}
!294 = metadata !{i32 34, i32 1, metadata !57, null}
!295 = metadata !{i32 16, i32 3, metadata !296, null}
!296 = metadata !{i32 786443, metadata !71, metadata !70, i32 16, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memcpy.c]
!297 = metadata !{i32 17, i32 5, metadata !70, null}
!298 = metadata !{metadata !271, metadata !271, i64 0}
!299 = metadata !{metadata !299, metadata !300, metadata !301}
!300 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!301 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!302 = metadata !{metadata !302, metadata !300, metadata !301}
!303 = metadata !{i32 18, i32 3, metadata !70, null}
!304 = metadata !{i32 16, i32 7, metadata !305, null}
!305 = metadata !{i32 786443, metadata !91, metadata !90, i32 16, i32 7, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!306 = metadata !{i32 19, i32 7, metadata !307, null}
!307 = metadata !{i32 786443, metadata !91, metadata !90, i32 19, i32 7, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!308 = metadata !{i32 20, i32 5, metadata !309, null}
!309 = metadata !{i32 786443, metadata !91, metadata !310, i32 20, i32 5, i32 3, i32 6} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!310 = metadata !{i32 786443, metadata !91, metadata !311, i32 20, i32 5, i32 1, i32 4} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!311 = metadata !{i32 786443, metadata !91, metadata !307, i32 19, i32 16, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!312 = metadata !{i32 20, i32 21, metadata !313, null}
!313 = metadata !{i32 786443, metadata !91, metadata !311, i32 20, i32 21, i32 2, i32 5} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!314 = metadata !{metadata !314, metadata !300, metadata !301}
!315 = metadata !{metadata !315, metadata !300, metadata !301}
!316 = metadata !{i32 22, i32 5, metadata !317, null}
!317 = metadata !{i32 786443, metadata !91, metadata !307, i32 21, i32 10, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!318 = metadata !{i32 24, i32 5, metadata !319, null}
!319 = metadata !{i32 786443, metadata !91, metadata !320, i32 24, i32 5, i32 3, i32 9} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!320 = metadata !{i32 786443, metadata !91, metadata !317, i32 24, i32 5, i32 1, i32 7} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!321 = metadata !{i32 23, i32 5, metadata !317, null}
!322 = metadata !{i32 24, i32 21, metadata !323, null}
!323 = metadata !{i32 786443, metadata !91, metadata !317, i32 24, i32 21, i32 2, i32 8} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memmove.c]
!324 = metadata !{metadata !324, metadata !300, metadata !301}
!325 = metadata !{metadata !325, metadata !300, metadata !301}
!326 = metadata !{i32 28, i32 1, metadata !90, null}
!327 = metadata !{i32 15, i32 3, metadata !328, null}
!328 = metadata !{i32 786443, metadata !103, metadata !102, i32 15, i32 3, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/mempcpy.c]
!329 = metadata !{i32 16, i32 5, metadata !102, null}
!330 = metadata !{metadata !330, metadata !300, metadata !301}
!331 = metadata !{metadata !331, metadata !300, metadata !301}
!332 = metadata !{i32 17, i32 3, metadata !102, null}
!333 = metadata !{i32 13, i32 5, metadata !334, null}
!334 = metadata !{i32 786443, metadata !115, metadata !114, i32 13, i32 5, i32 1, i32 0} ; [ DW_TAG_lexical_block ] [/playpen/ziqiao/2project/klee/runtime/Intrinsic/memset.c]
!335 = metadata !{i32 14, i32 7, metadata !114, null}
!336 = metadata !{i32 15, i32 5, metadata !114, null}
