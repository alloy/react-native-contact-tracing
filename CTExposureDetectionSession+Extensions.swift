// Taken from https://gist.github.com/mattt/17c880d64c362b923e13c765f5b1c75a,
//
// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to https://unlicense.org

// import ContactTracking

extension CTExposureDetectionSession {
    func addPositiveDiagnosisKeys(batching keys: [CTDailyTracingKey], completion: CTErrorHandler) {
        if keys.isEmpty {
            completion(nil)
        } else {
            let cursor = keys.index(keys.startIndex, offsetBy: maxKeyCount, limitedBy: keys.endIndex) ?? keys.endIndex
            let batch = Array(keys.prefix(upTo: cursor))
            let remaining = Array(keys.suffix(from: cursor))

            withoutActuallyEscaping(completion) { escapingCompletion in
                addPositiveDiagnosisKeys(batch) { (error) in
                    if let error = error {
                        escapingCompletion(error)
                    } else {
                        self.addPositiveDiagnosisKeys(batching: remaining, completion: escapingCompletion)
                    }
                }
            }
        }
    }
}