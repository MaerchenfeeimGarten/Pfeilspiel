'
' SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
' 
' SPDX-License-Identifier:  AGPL-3.0-only
'

namespace strings

    sub InsertStr overload (byref s1 as string, byref s2 as const string, _
    byval start as uinteger)
        ' in <s1> insert <s2> at <start>
        s1 = left(s1, start - 1) + s2 + mid(s1, start)
    end sub

    sub InsertStr overload (byref s1 as string, byref s2 as const string, _
    byval start as uinteger, byval count as uinteger)
        ' in <s1> insert <s2> at <start> and replace <count> characters
        s1 = left(s1, start - 1) + s2 + mid(s1, start + count)
    end sub

    sub Replace(byref s1 as string, byref s2 as const string, _
    byref s3 as const string)
        ' in <s1> replace <s2> by <s3>
        dim p as uinteger
        
        if s3 <> s2 then
            p = instr(s1, s2)
            if p then
                InsertStr(s1, s3, p, len(s2))
            end if
        end if
    end sub

    sub ReplaceAll(byref s1 as string, byref s2 as const string, _
    byref s3 as const string)
        ' in <s1> replace all occurrences of <s2> by <s3>
        dim p as uinteger
        dim q as uinteger
        
        if s3 <> s2 then
            p = instr(s1, s2)
            if p then
                q = len(s3)
                if q = 0 then q = 1
                do
                    InsertStr(s1, s3, p, len(s2))
                    p = instr(p + q, s1, s2)
                loop until p = 0
            end if
        end if
    end sub 

end namespace
