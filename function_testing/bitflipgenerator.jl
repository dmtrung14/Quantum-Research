function flip_i_bit(i, string)
    return string ⊻ 1 << i
    # so we don't need bitstring() to perform the xor bitflipping
    # return bitstring(string ⊻ 1 <<i)
    # # flip from right to left
end
function bitflip_generator(SAMPLE_SIZE, length, error_rate, string)
    #for any codeword, generate a number of bitflips(or not) with probability of p.
    res = String[]
    for sample in 1:SAMPLE_SIZE
        codeword = string
        for i in 1:length
            p =rand()
            if p < error_rate
                codeword = flip_i_bit(i, codeword)
                # codeword = parse(UInt, flip_i_bit(i, codeword) ; base=2)
            end
        end
        push!(res, last(bitstring(codeword),length))
        #add the last length digit of bitstring to the result
    end
    
    return res
end
print(bitflip_generator(1000, 6, 0.2, 010001))