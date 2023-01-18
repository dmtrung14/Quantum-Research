module BitflipGenerator
    function flip_i_bit(n,i, string)
        return bitstring(string ⊻ 1 <<i)
        # flip from right to left
    end
    function bitflip_generator(SAMPLE_SIZE, length, error_rate, string)
        #for any codeword, generate a number of bitflips(or not) with probability of p.
        res = Int8[]
        for sample in 1:SAMPLE_SIZE
            codeword = string
            for i in 1:length
                p =rand(1)
                if p < error_rate
                    codeword = flip_i_bit(n,i,codeword)
                end
            end
            push!(res, codeword)
        end
        
        return res
    end
end # module BitflipGenerator
