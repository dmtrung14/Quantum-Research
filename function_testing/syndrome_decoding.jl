function get_parity_check_matrix(x,y)
    s = zeros(Int8, x)
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
    for i in 1:2^n
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
function syndrome_decoding(TOTAL_SAMPLES, noisy_code_word, correct_code_word)
    H = get_parity_check_matrix(2,3)
    correct_answer = 0 
    for sample in 1:TOTAL_SAMPLES        
        syndrome = calculate_syndrome(H,noisy_code_word)
        decoded_logical_value = decode_syndrome(H, syndrome)[1] ⊻ noisy_code_word
        # println(decoded_logical_value)
        if string(decoded_logical_value) == correct_code_word
            correct_answer +=1
        end
    end
    return correct_answer / TOTAL_SAMPLES
end