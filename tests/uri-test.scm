(import 
  (scheme base)
  (lib uri)
  (cyclone test))

(test-group "Original encoding tests"
  (test "encode empty" 
        ""
        (encode ""))
  (test "encode something" 
        "something"
        (encode "something"))
  (test "encode space"  
        "%20"
        (encode " "))
  (test "encode percent"  
         "%25%2520"
         (encode "%%20"))
  (test "encode latin1"  
        "%7Cabc%C3%A5"
        (encode "|abcå"))
  (test "encode symbols"  
        "~%2A%27%28%29"
        (encode "~*'()"))
  (test "encode angles"  
        "%3C%22%3E"
        (encode "<\">"))
  (test "encode latin1 utf8"  
        "%C3%A5%C3%A4%C3%B6"
        (encode "åäö"))
  (test "encode utf8"  
        "%E2%9D%A4"
        (encode "❤" ))
)

(test-group "Original decoding tests"
  (test "decode empty" "" (decode ""))
  (test "decode something" "something" (decode "something"))
  (test "decode something percent" "something%" (decode "something%"))
  (test "decode something percenta" "something%a" (decode "something%a"))
  (test "decode something zslash" "something%Z/" (decode "something%Z/"))
  (test "decode space" " " (decode "%20"))
  (test "decode percents" "%%20" (decode "%25%2520"))
  (test "decode latin1" "|abcå" (decode "%7Cabc%C3%A5"))
  (test "decode symbols" "~*'()" (decode "~%2A%27%28%29"))
  (test "decode angles" "<\">" (decode "%3C%22%3E"))
  ;(test "decode middle null" "ABC\0" (decode "ABC%00DEF"))
)

(test-exit)
