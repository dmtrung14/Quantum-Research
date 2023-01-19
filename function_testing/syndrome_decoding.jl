function flip_i_bit(i, string)
    return string ⊻ 1 << (i-1)
    # so we don't need bitstring() to perform the xor bitflipping
    # return bitstring(string ⊻ 1 <<i)
    # # flip from right to left
end
function bitflip_generator(SAMPLE_SIZE, length, error_rate, string)
    #for any codeword, generate a number of bitflips(or not) with probability of p.
    res = Int8[]
    for sample in 1:SAMPLE_SIZE
        codeword = string
        for i in 1:length
            p =rand()
            if p < error_rate
                codeword = flip_i_bit(i, codeword)
                # codeword = parse(UInt, flip_i_bit(i, codeword) ; base=2)
            end
        end
        push!(res, codeword)
        #add the last length digit of bitstring to the result
    end
    
    return res
end
function get_parity_check_matrix(columns, source)
    s = Int8[]
    for i in source
        push!(s, i)
    end
    #Placeholder: for every rows in the matrix, enter a binary string with length y
    return s
end

function calculate_syndrome(H, x)
    m = size(H,1)
    res = 0
    
    for i in 1:m
        res_string = H[i] & x
        res = res << 1 + count_ones(res_string)%2
    end
    return res
end

#Creating a map of syndrome vs errors
function syndrome_key_map(H)
    hashmap = Dict()
    n = size(H,1)
    for i in 0:2^n
        if calculate_syndrome(H,i) ∉ keys(hashmap)
            hashmap[calculate_syndrome(H,i)] = Int8[]
            push!(hashmap[calculate_syndrome(H,i)], i)
        else 
            push!(hashmap[calculate_syndrome(H,i)], i)
        end
    end
    return hashmap
end


# Return an Array of all possible errors
function decode_syndrome(H,s)
    hashmap = syndrome_key_map(H)
    hashmap[s] = sort(hashmap[s], by=count_ones)
    return hashmap[s]
    # return an array
end

# Syndrome Decoding function
function syndrome_decoding(H, noisy_code_word)         
    syndrome = calculate_syndrome(H,noisy_code_word)
    decoded_logical_value = decode_syndrome(H, syndrome)[1] ⊻ noisy_code_word
    return decoded_logical_value
end


#Test
matrix_list = [0b010, 0b101]
H = get_parity_check_matrix(2, matrix_list)
correct_codeword = 0b101
for i in bitflip_generator(1000, 3, 0.2, correct_codeword)
    println(bitstring(syndrome_decoding(H, i)))
end
